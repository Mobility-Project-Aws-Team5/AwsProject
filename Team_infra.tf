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

resource "aws_iam_group_policy_attachment" "infra_team_vpc_access" {
  group      = aws_iam_group.infra_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}