output "s3_bucket_pictures_id" {
  description = "The id of pictures s3 bucket"
  value       = aws_s3_bucket.pictures.id
}

output "s3_bucket_pictures_arn" {
  description = "The S3 bucket ARN"
  value       = aws_s3_bucket.pictures.arn
}