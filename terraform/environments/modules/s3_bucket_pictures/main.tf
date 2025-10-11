#S3 bucket to save the pictures

resource "aws_s3_bucket" "pictures" {
  bucket = "${replace(var.environment, "_", "-")}-webapp-pictures"
  
  tags = {
    Name = "${var.environment}-pictures-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "pictures_ownership" {
  bucket = aws_s3_bucket.pictures.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


resource "aws_s3_bucket_public_access_block" "pictures_public_access" {
  bucket = aws_s3_bucket.pictures.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
