# ============================================================================
# S3 - File Storage
# ============================================================================

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "transcriptions" {
  bucket = "admin-portal-transcriptions-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "admin-portal-transcriptions"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "transcriptions" {
  bucket = aws_s3_bucket.transcriptions.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_encryption" "transcriptions" {
  bucket = aws_s3_bucket.transcriptions.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "transcriptions" {
  bucket = aws_s3_bucket.transcriptions.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "transcriptions" {
  bucket = aws_s3_bucket.transcriptions.id

  rule {
    id     = "archive-old-files"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }
  }
}
