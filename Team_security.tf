resource "aws_iam_user" "gyudol" {
  name = "gyudol"
}

resource "aws_iam_user" "yearhui" {
  name = "yearhui"
}

resource "aws_iam_group" "security_team" {
  name = "security_team"
}

resource "aws_iam_group_membership" "security_team_membership" {
  name = "security_team_membership"
  users = [
    aws_iam_user.gyudol.name,
    aws_iam_user.yearhui.name,
  ]
  group = aws_iam_group.security_team.name
}

resource "aws_iam_group_policy_attachment" "security_team_cloudwatch" {
  group      = aws_iam_group.security_team.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

# 보안팀에 CloudTrailFullAccess 정책 부여
resource "aws_iam_group_policy_attachment" "security_team_cloudtrail" {
  group      = aws_iam_group.security_team.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrail_FullAccess"
}

# 보안팀에 AWSWAFFullAccess 정책 부여
resource "aws_iam_group_policy_attachment" "security_team_waf_shield" {
  group      = aws_iam_group.security_team.name
  policy_arn = "arn:aws:iam::aws:policy/AWSWAFFullAccess"
}

# 보안팀에 AmazonS3FullAccess 정책 부여
resource "aws_iam_group_policy_attachment" "security_team_s3" {
  group      = aws_iam_group.security_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# 보안팀에 IAMFullAccess 정책 부여
resource "aws_iam_group_policy_attachment" "security_team_iam" {
  group      = aws_iam_group.security_team.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

# 보안팀에 AmazonSNSFullAccess 정책 부여
resource "aws_iam_group_policy_attachment" "security_team_sns" {
  group      = aws_iam_group.security_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}


resource "aws_iam_policy" "security_group_policy" {
  name        = "SecurityGroupPolicy"
  description = "Policy for managing EC2 security groups"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSecurityGroups"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# 보안팀에 사용자 정의 EC2 보안 그룹 정책 부여
resource "aws_iam_group_policy_attachment" "security_team_custom_ec2" {
  group      = aws_iam_group.security_team.name
  policy_arn = aws_iam_policy.security_group_policy.arn
}

resource "aws_iam_policy" "security_team_route53_write_policy" {
  name        = "Route53SecurityGroupWritePolicy"
  description = "Policy for Route 53 to manage security groups"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "security_team_route53_attachment" {
  group      = aws_iam_group.security_team.name
  policy_arn = aws_iam_policy.security_team_route53_write_policy.arn
}

resource "aws_iam_policy" "security_team_vpc_policy" {
  name        = "VPCNetworkManagementPolicy"
  description = "Policy for managing VPC-related resources (Network ACL, Security Groups, Firewalls, and VPN)"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # 네트워크 ACL 관리 권한
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkAcl",
          "ec2:DeleteNetworkAcl",
          "ec2:CreateNetworkAclEntry",
          "ec2:DeleteNetworkAclEntry",
          "ec2:DescribeNetworkAcls"
        ]
        Resource = "*"
      },
      # 보안 그룹 관리 권한
      {
        Effect = "Allow"
        Action = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      },
      # 방화벽 관리 권한 (AWS Network Firewall)
      {
        Effect = "Allow"
        Action = [
          "network-firewall:CreateFirewall",
          "network-firewall:DeleteFirewall",
          "network-firewall:DescribeFirewalls",
          "network-firewall:UpdateFirewallPolicy",
          "network-firewall:AssociateFirewallPolicy",
          "network-firewall:ListFirewalls"
        ]
        Resource = "*"
      },
      # VPN 관리 권한
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateVpnConnection",
          "ec2:DeleteVpnConnection",
          "ec2:DescribeVpnConnections",
          "ec2:CreateVpnGateway",
          "ec2:DeleteVpnGateway",
          "ec2:DescribeVpnGateways",
          "ec2:AttachVpnGateway",
          "ec2:DetachVpnGateway"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "vpc_network_management_attachment" {
  group      = aws_iam_group.security_team.name
  policy_arn = aws_iam_policy.security_team_vpc_policy.arn
}

