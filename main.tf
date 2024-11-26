terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region  = "ap-northeast-2"
  profile = "terraform-user"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = "eks-vpc"
  cidr            = "172.28.0.0/16"
  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  private_subnets = ["172.28.11.0/24", "172.28.31.0/24"]
  public_subnets  = ["172.28.10.0/24", "172.28.30.0/24"]

  # Kubernetes에서 AWS ELB를 사용하여 서비스의 로드밸런싱 자동화 설정
  public_subnet_tags = {
    # 인터넷에 노출된 ELB
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    # VPC 내에서만 접근 가능한 ELB
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  # EKS Cluster Setting
  cluster_name    = "my-eks"
  cluster_version = "1.30"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  # EKS Worker Node 정의 ( ManagedNode방식: Launch Template 자동 구성 )
  eks_managed_node_groups = {
    initial = {
      instance_types         = ["t3.small"]
      min_size               = 2
      max_size               = 3
      desired_size           = 2
      vpc_security_group_ids = [module.add_node_sg.security_group_id]
    }
  }

  # public-subnet(bastion)과 API와 통신하기 위해 설정(443)
  cluster_additional_security_group_ids = [module.add_cluster_sg.security_group_id]
  cluster_endpoint_public_access        = true

  # AWS EKS 클러스터를 생성할 때, 
  # 해당 클러스터를 생성한 IAM 사용자에게 관리자 권한을 부여하는 옵션
  # K8s ConfigMap Object "aws_auth" 구성
  # 구성 후 명령어로 확인 가능, kubectl -n kube-system get configmap aws-auth -o yaml
  enable_cluster_creator_admin_permissions = true
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

module "bastion_host" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  depends_on                  = [module.eks]
  ami                         = "ami-03d31e4041396b53c"
  name                        = "bastion-host"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "public-ec2-key"
  monitoring                  = true
  vpc_security_group_ids      = [module.bastion_host_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  disable_api_termination     = true
  user_data = templatefile("${path.module}/userdata.sh.tpl",
    {
      ACCESS_KEY = var.access_key
      SECRET_KEY = var.secret_key
    }
  )
}

module "nat_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami                         = "ami-01ad0c7a4930f0e43"
  name                        = "nat-instance"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "public-ec2-key"
  source_dest_check           = false
  vpc_security_group_ids      = [module.nat_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[1]
}

# Private Subnet Routing Table ( dest: NAT Instance ENI )
resource "aws_route" "private_subnet" {
  count                  = 2
  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.nat_instance.primary_network_interface_id
}

output "bastion_ip" {
  value       = module.bastion_host.public_ip
  description = "bastion-host public IP"
}

resource "aws_kms_key" "mykey" {
  description             = "mykey KMS key" # trail s3 bucket encryption
  key_usage               = "SIGN_VERIFY" # Default usage for most cases
  customer_master_key_spec = "RSA_2048" # Symmetric key type
  deletion_window_in_days = 7 # Retention period after deletion (7-30 days)
}



/*
C:\terraform\workspace> cd .\00_eks\
C:\terraform\workspace\00_eks> terraform fmt
C:\terraform\workspace\00_eks> terraform init 
C:\terraform\workspace\00_eks> terraform apply
C:\terraform\workspace\00_eks> terraform destroy
*/
