# # Fetch the current AWS account ID
# data "aws_iam_user" "existing_user" {
#   user_name = "${var.user_name}"
# }

# # Check if the policy already exists
# data "aws_iam_policy" "existing_policy" {
#   name = "${var.policy_name}"
# }