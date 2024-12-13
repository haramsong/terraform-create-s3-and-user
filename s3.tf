resource "aws_s3_bucket" "introduce_oh_website" {
  bucket = "introduce-oh-website-bucket"

  tags = {
    Name        = "introduce-oh-website-bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "introduce_oh_bucket_acl" {
  bucket = aws_s3_bucket.introduce_oh_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_website_configuration" "introduce_oh_website_config" {
  bucket = aws_s3_bucket.introduce_oh_website.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "introduce_oh_cors_rule" {
  bucket = aws_s3_bucket.introduce_oh_website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "introduce_oh_website_policy" {
  bucket = aws_s3_bucket.introduce_oh_website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::introduce-oh-website-bucket/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.introduce_oh_bucket_acl]
}
