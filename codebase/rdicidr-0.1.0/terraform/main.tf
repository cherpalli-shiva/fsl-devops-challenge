# In this file put all the logic to crete the proper infraestructure
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }

    required_version = ">= 1.6.0"
}

provider "aws" {
    region = var.aws_region
}


#S3 Bucket
resource "aws_s3_bucket" "react_site" {
  bucket = "${var.project_name}-${var.environment}-site"
  force_destroy = true
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.react_site.id

    index_document {
      suffix = "index.html"
    }

    error_document {
      key = "index.html"
    }
}

# access
resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.react_site.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.react_site.arn}/*"]
      }
    ]
  })
}
resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket                  = aws_s3_bucket.react_site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

output "webiste_url" {
    value = aws_s3_bucket_website_configuration.website.website_endpoint
}