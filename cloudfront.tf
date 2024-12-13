resource "aws_cloudfront_origin_access_control" "oac" {
  name                                = "oac-for-${var.bucket_name}"
  origin_access_control_origin_type   = "s3"
  signing_behavior                    = "always"
  signing_protocol                    = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.introduce_oh_website.bucket_regional_domain_name
    origin_id   = "S3-${var.bucket_name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_control.oac.id
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for ${var.bucket_name}"
  default_root_object = "index.html"
  aliases = ["happy-birthday.dhtmdgkr123.com"]

  viewer_certificate {
    acm_certificate_arn = "*.dhtmdgkr123.com"
    ssl_support_method  = "sni-only"
  }

  default_cache_behavior {
    target_origin_id       = "S3-${var.bucket_name}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" 
    }
  }
}
