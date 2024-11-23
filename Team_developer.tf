resource "aws_iam_user" "joonsu" {
  name = "joonsu"
}

resource "aws_iam_group" "developer_team" {
  name = "developer_team"
}

resource "aws_iam_group_membership" "developer_team_membership" {
  name = "developer_team_membership"
  users = [
    aws_iam_user.joonsu.name,
  ]
  group = aws_iam_group.developer_team.name
}

resource "aws_iam_group_policy_attachment" "developer_team_cloudwatch" {
  group      = aws_iam_group.developer_team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
