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
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
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

# 보안팀에 AmazonAPIGatewayAdministrator 정책 부여
resource "aws_iam_group_policy_attachment" "security_team_gateway" {
  group      = aws_iam_group.security_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
}
