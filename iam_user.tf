resource "aws_iam_user" "my" {
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
        Sid = "ListAllMyBuckets",
        Effect = "Allow",
        Action = "s3:ListAllMyBuckets",
        Resource = "arn:aws:s3:::*"
      },
      {
        Sid = "SettingBucket",
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
        ],
        Resource = ["arn:aws:s3:::${var.bucket_name}"]
      },
      {
        Sid = "SettingBucketObjects",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ],
        Resource = ["arn:aws:s3:::${var.bucket_name}/*"]
      },
      {
        Sid = "GetParameter",
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "ssm:DescribeParameters",
        ],
        Resource = [
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter${var.ssm_parameter_name}",
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter${var.ssm_parameter_name}/*",
        ]
      },
      {
        Sid = "CreateInvalidation",
        Effect = "Allow",
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations",
          "cloudfront:GetDistribution",
          "cloudfront:ListDistributions",
        ],
        Resource = [
          "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.cdn.id}",
          "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:invalidation/*",
        ]
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "my_policy_attachment" {
  user       = aws_iam_user.my.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_user_login_profile" "my_login" {
  user                    = aws_iam_user.my.name
  password_reset_required = true
}

resource "aws_iam_access_key" "my_access_key" {
  user = aws_iam_user.my.name
}