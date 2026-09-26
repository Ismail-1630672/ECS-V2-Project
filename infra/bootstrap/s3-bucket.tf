resource "aws_s3_bucket" "bootstrap_s3_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bootstrap_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.bootstrap_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_kms_key" "encrypt_objects" {
  deletion_window_in_days = 10
  enable_key_rotation     = true
  description             = "This key is used to convert readable data into unreadable data"
}

resource "aws_kms_alias" "key_alias" {
  name          = "alias/${var.project_name}-key-alias"
  target_key_id = aws_kms_key.encrypt_objects.key_id
}


resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bootstrap_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.encrypt_objects.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }

}