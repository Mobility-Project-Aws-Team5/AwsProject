resource "aws_iam_user" "taeyoon" {
  name = "taeyoon"
}

resource "aws_iam_group" "infra_team" {
  name = "infra_team"
}

resource "aws_iam_group_membership" "infra_team_membership" {
  name = "infra_team_membership"
  users = [
    aws_iam_user.taeyoon.name,
  ]
  group = aws_iam_group.infra_team.name
}

# 보안팀에 AmazonS3FullAccess 정책 부여
resource "aws_iam_group_policy_attachment" "infra_team_s3" {
  group      = aws_iam_group.infra_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# 보안팀에 AmazonAPIGatewayAdministrator 정책 부여
resource "aws_iam_group_policy_attachment" "infra_team_gateway" {
  group      = aws_iam_group.infra_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
}

resource "aws_iam_group_policy_attachment" "infra_team_network_readonly" {
  group      = aws_iam_group.infra_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}