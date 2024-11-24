# 사용자 정의
resource "aws_iam_user" "joonsu" {
  name = "joonsu"
}

# 그룹 정의
resource "aws_iam_group" "developer_team" {
  name = "developer_team"
}

# 사용자 그룹에 추가
resource "aws_iam_group_membership" "developer_team_membership" {
  name = "developer_team_membership"
  users = [
    aws_iam_user.joonsu.name,
  ]
  group = aws_iam_group.developer_team.name
}

# EC2 읽기 전용 접근 권한
resource "aws_iam_group_policy_attachment" "developer_team_cloudwatch" {
  group      = aws_iam_group.developer_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# 서브넷, IGW, 라우팅 테이블, NAT 및 방화벽에 대한 읽기 권한 정책 첨부
resource "aws_iam_group_policy_attachment" "developer_team_network_readonly" {
  group      = aws_iam_group.developer_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess"
}

resource "aws_iam_policy" "developer_team_vpn_policy" {
  name        = "VPNFullAccessPolicy"
  description = "Full access to VPN resources including VPN connections, gateways, and associated configurations"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
          "ec2:DetachVpnGateway",
          "ec2:ModifyVpnConnection",
          "ec2:DescribeVpnConnectionRoutes",
          "ec2:ReplaceVpnConnectionRoute",
          "ec2:DeleteVpnConnectionRoute"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeVpnCustomerGateways",
          "ec2:CreateVpnCustomerGateway",
          "ec2:DeleteVpnCustomerGateway"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "developer_team_vpn_policy_attachment" {
  group      = aws_iam_group.developer_team.name
  policy_arn = aws_iam_policy.developer_team_vpn_policy.arn
}



resource "aws_iam_policy" "route53_custom_policy" {
  name        = "Route53CustomPolicy"
  description = "Custom policy for Route 53 with security group exclusions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:*",
          "route53domains:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Deny"
        Action = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "route53_policy_attachment" {
  group      = aws_iam_group.developer_team.name
  policy_arn = aws_iam_policy.route53_custom_policy.arn
}
