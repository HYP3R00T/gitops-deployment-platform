# Development policy for broad access to build and deploy resources
resource "aws_iam_policy" "terraform_dev_policy" {
  name = "terraform-dev-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowInfrastructureLifecycle"
        Effect = "Allow"
        Action = [
          "eks:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "iam:*",
          "sts:PassRole",
          "logs:*",
          "cloudwatch:*",
          "kms:*"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = "ap-south-1"
          }
        }
      },
      {
        Sid    = "AllowS3StateReadWrite"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::gitops-tfstate-6a95bb4d/dev/*"
      },
      {
        Sid    = "AllowS3ListBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::gitops-tfstate-6a95bb4d"
        Condition = {
          StringLike = {
            "s3:prefix" = [
              "",
              "dev/*"
            ]
          }
        }
      }
    ]
  })
}

# Production policy for full infrastructure lifecycle with resource scoping
# Uses tag-based conditions (Environment=prod) combined with region restriction
# Explicit denies for dangerous bucket-level operations
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
        Sid    = "AllowInfrastructureLifecycle"
        Effect = "Allow"
        Action = [
          "eks:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "iam:*",
          "sts:PassRole",
          "logs:*",
          "cloudwatch:*",
          "kms:*"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:RequestedRegion"         = "ap-south-1"
            "aws:ResourceTag/Environment" = "prod"
          }
        }
      },
      {
        Sid    = "AllowS3StateReadWrite"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::gitops-tfstate-6a95bb4d/prod/*",
          "arn:aws:s3:::gitops-tfstate-6a95bb4d/identity/*"
        ]
      },
      {
        Sid    = "AllowS3ListBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::gitops-tfstate-6a95bb4d"
        Condition = {
          StringLike = {
            "s3:prefix" = [
              "",
              "prod/*",
              "identity/*"
            ]
          }
        }
      }
    ]
  })
}
