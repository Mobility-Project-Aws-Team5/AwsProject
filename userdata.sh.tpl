#!/bin/bash

ACCESS_KEY="${ACCESS_KEY}" # 테라폼에서의 변수를 shell script에 담고 그것을 출력 결과로 이용
SECRET_KEY="${SECRET_KEY}"

# AWS CLI configure
sudo -u ec2-user aws configure set aws_access_key_id "${ACCESS_KEY}" --profile admin
sudo -u ec2-user aws configure set aws_secret_access_key "${SECRET_KEY}" --profile admin
sudo -u ec2-user aws configure set region ap-northeast-2 --profile admin

# Create bin directory and move kubectl there
sudo -u ec2-user mkdir -p /home/ec2-user/bin

# Download kubectl
sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.4/2024-09-11/bin/linux/amd64/kubectl


# File Move
sudo mv /kubectl /home/ec2-user/bin/kubectl 

# Make kubectl executable
sudo chown ec2-user:ec2-user /home/ec2-user/bin/kubectl # 권한 다운그레이드
sudo chmod +x /home/ec2-user/bin/kubectl

# Update kubeconfig for EKS
sudo -u ec2-user aws eks update-kubeconfig --region ap-northeast-2 --name my-eks --profile admin


