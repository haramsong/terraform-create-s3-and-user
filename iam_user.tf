variable "bucket_name" {}

resource "aws_iam_user" "hrsong" {
  name          = "hrsong"
  force_destroy = true

  tags = {
    Name = "hrsong"
  }
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "hrsong-s3-access-policy"
  description = "Policy to allow access to introduce-oh-website-bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "s3:ListAllMyBuckets",
        "Resource" : "arn:aws:s3:::*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:*BucketPolicy",
          "s3:*PublicAccessBlock",
          "s3:*BucketAcl",
          "s3:*BucketCORS",
          "s3:*BucketWebsite",
        ],
        Resource = ["arn:aws:s3:::${var.bucket_name}"]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ],
        Resource = ["arn:aws:s3:::${var.bucket_name}/*"]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "hrsong_policy_attachment" {
  user       = aws_iam_user.hrsong.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_user_login_profile" "hrsong_login" {
  user                    = aws_iam_user.hrsong.name
  password_reset_required = true
}
