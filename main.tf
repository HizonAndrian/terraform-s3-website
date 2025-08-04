resource "aws_s3_bucket" "s3_bucket" {
  bucket = "cloudriann.com"
}

moved {
  to   = aws_s3_bucket.s3_bucket
  from = aws_s3_bucket.name
}

resource "aws_s3_bucket_website_configuration" "s3_web_configuration" {

  bucket = aws_s3_bucket.s3_bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "name" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = "index.html"
  source       = "./html/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_public_access_block" "name" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.s3_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cloudfront_config.arn
          }
        }
      }
    ]
  })
}
