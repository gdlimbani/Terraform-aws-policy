# Define the policy
resource "aws_iam_policy" "my_policy" {
  count       = length(data.aws_iam_policy.existing_policy.id) == 0 ? 1 : 0
  name        = "${var.policy_name}"
  description = "Gdl custom IAM policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement: [
		{
			"Effect": "Allow",
			"Action": [
				"kms:CreateKey",
				"kms:DescribeKey",
				"kms:ListKeys",
				"kms:TagResource",
				"kms:CreateAlias",
				"kms:DeleteAlias",
				"kms:ListAliases",
				"kms:PutKeyPolicy"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"logs:CreateLogGroup",
				"logs:TagResource",
				"logs:DescribeLogGroups",
				"logs:ListTagsForResource",
				"logs:PutLogEvents",
				"logs:DeleteLogGroup",
				"logs:CreateLogStream",
				"logs:PutRetentionPolicy"
			],
			"Resource": "*"
		}
	]
  })
  lifecycle {
    prevent_destroy = false
  }
}

# Attach the policy to the user if they exist
resource "aws_iam_policy_attachment" "user_policy_attachment" {
  count = length(data.aws_iam_user.existing_user.id) > 0 && length(aws_iam_policy.my_policy) > 0 ? 1 : 0
  name      = "my_policy_attachment"
  users     = [data.aws_iam_user.existing_user.user_name]
  policy_arn = aws_iam_policy.my_policy[0].arn
}

# Ensure the policy is detached first before destroying it
resource "aws_iam_policy_attachment" "detach_user_policy" {
  count = length(data.aws_iam_user.existing_user.id) > 0 && length(aws_iam_policy.my_policy) > 0 ? 1 : 0
  name      = "detach_my_policy"
  users     = [data.aws_iam_user.existing_user.user_name]
  policy_arn = aws_iam_policy.my_policy[0].arn
  lifecycle {
    prevent_destroy = false
  }
}