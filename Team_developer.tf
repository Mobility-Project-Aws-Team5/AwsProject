resource "aws_iam_user" "joonsu" {
  name = "joonsu"
}

resource "aws_iam_group" "developer_team" {
  name = "developer_team"
}
