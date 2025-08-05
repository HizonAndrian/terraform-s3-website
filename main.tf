resource "aws_s3_bucket" "s3_bucket" {
  bucket = "cloudriann.com"
}

resource "aws_s3_bucket_website_configuration" "s3_web_configuration" {

  bucket = aws_s3_bucket.s3_bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership_control" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "s3_object" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = "index.html"
  source       = "./html/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error_page" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = "error.html"
  source       = "./html/error.html"
  content_type = "text/html"
}


resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AllowCloudFrontRead",
        Effect: "Allow",
        Principal: {
          Service: "cloudfront.amazonaws.com"
        },
        Action: "s3:GetObject",
        Resource: "${aws_s3_bucket.s3_bucket.arn}/*"
      }
    ]
  })
}


