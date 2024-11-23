resource "aws_iam_user" "taeyoon" {
  name = "taeyoon"
}

resource "aws_iam_user" "gyudol" {
  name = "gyudol"
}

resource "aws_iam_user" "joonsu" {
  name = "joonsu"
}

resource "aws_iam_user" "yearhui" {
  name = "yearhui"
}

resource "aws_iam_group" "db_team" {
  name = "db_team"
}

resource "aws_iam_group" "security_team" {
  name = "security_team"
}

resource "aws_iam_group" "developer_team" {
  name = "developer_team"
}

resource "aws_iam_group" "network_team" {
  name = "network_team"
}

resource "aws_iam_group_membership" "db_team_membership" {
  name = "db_team_membership"
  users = [
    aws_iam_user.taeyoon.name,
  ]
  group = aws_iam_group.db_team.name
}

resource "aws_iam_group_membership" "security_team_membership" {
  name = "security_team_membership"
  users = [
    aws_iam_user.gyudol.name,
  ]
  group = aws_iam_group.security_team.name
}

resource "aws_iam_group_membership" "developer_team_membership" {
  name = "developer_team_membership"
  users = [
    aws_iam_user.joonsu.name,
  ]
  group = aws_iam_group.developer_team.name
}

resource "aws_iam_group_membership" "network_team_membership" {
  name = "network_team_membership"
  users = [
    aws_iam_user.yearhui.name,
  ]
  group = aws_iam_group.network_team.name
}

# DB팀에 AmazonVPCFullAccess 정책 부여
resource "aws_iam_group_policy_attachment" "db_team_vpc_access" {
  group      = aws_iam_group.db_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

# 보안팀에 CloudWatchFullAccess 정책 부여
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
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# 보안팀에 IAMFullAccess 정책 부여
resource "aws_iam_group_policy_attachment" "security_team_iam" {
  group      = aws_iam_group.security_team.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

# gyudol 사용자에게 액세스 키 생성
resource "aws_iam_access_key" "gyudol_access_key" {
  user = aws_iam_user.gyudol.name

  # 출력에 민감한 정보 포함 방지
  lifecycle {
    prevent_destroy = true
  }
}

# 액세스 키와 시크릿 키 출력 (Terraform 출력 변수 추가)
output "gyudol_access_key" {
  value = aws_iam_access_key.gyudol_access_key.id
  sensitive = true
}

output "gyudol_secret_key" {
  value = aws_iam_access_key.gyudol_access_key.secret
  sensitive = true
}
