# Development policy for broad access to build and deploy resources
resource "aws_iam_policy" "terraform_dev_policy" {
  name = "terraform-dev-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["eks:*", "ec2:*", "elasticloadbalancing:*", "autoscaling:*"]
        Resource = "*"
      }
    ]
  })
}

# Production policy for restricted state management access only
# Uses exact S3 bucket ARN with explicit denies for dangerous operations
resource "aws_iam_policy" "terraform_prod_policy" {
  name = "terraform-prod-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyDangerousS3Actions"
        Effect = "Deny"
        Action = [
          "s3:DeleteBucket",
          "s3:PutBucketPolicy",
          "s3:PutBucketAcl",
          "s3:DeleteBucketPolicy",
          "s3:PutEncryptionConfiguration",
          "s3:DeleteEncryptionConfiguration",
          "s3:PutBucketVersioning"
        ]
        Resource = "arn:aws:s3:::gitops-tfstate-6a95bb4d"
      },
      {
        Sid    = "AllowS3StateReadWrite"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::gitops-tfstate-6a95bb4d/*"
      },
      {
        Sid    = "AllowS3ListBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::gitops-tfstate-6a95bb4d"
      }
    ]
  })
}
