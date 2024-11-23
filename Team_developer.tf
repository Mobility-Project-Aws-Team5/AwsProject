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

# VPN에 대한 전체 접근 권한 정책 첨부
resource "aws_iam_group_policy_attachment" "developer_team_vpn_fullaccess" {
  group      = aws_iam_group.developer_team.name
  policy_arn = "arn:aws:iam::aws:policy/ClientVPNServiceConnectionsRolePolicy"
}
