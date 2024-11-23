resource "aws_iam_user" "taeyoon" {
  name = "taeyoon"
}

resource "aws_iam_group" "db_team" {
  name = "db_team"
}

resource "aws_iam_group_membership" "db_team_membership" {
  name = "db_team_membership"
  users = [
    aws_iam_user.taeyoon.name,
  ]
  group = aws_iam_group.db_team.name
}

resource "aws_iam_group_policy_attachment" "db_team_vpc_access" {
  group      = aws_iam_group.db_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}