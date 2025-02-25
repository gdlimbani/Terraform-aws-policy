# Create EKS IAM role
resource "aws_iam_role" "eks_role" {
  name = "${var.role_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      },
      {
        Effect    = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action    = "sts:AssumeRole",
        Sid       = ""
      }
    ]
  })
}

# Attach the EKS managed policy to the role
resource "aws_iam_role_policy_attachment" "eks_role_policy_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create a custom policy for EKS
resource "aws_iam_policy" "eks_custom_policy" {
  name        = "${var.policy_name}"
  description = "Custom policy for EKS role"

  policy = jsonencode({
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
}

# Attach the custom policy to the role
resource "aws_iam_role_policy_attachment" "eks_custom_policy_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.eks_custom_policy.arn
}
