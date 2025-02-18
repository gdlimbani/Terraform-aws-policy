# Fetch the current AWS account ID
data "aws_iam_user" "existing_user" {
  user_name = "${var.user_name}"
}