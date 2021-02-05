output "builds_s3_bucket_name" {
  value = aws_s3_bucket.builds_bucket.bucket
  description = "Name of the s3 bucket containing the builds"
}

output "builds_s3_bucket_arn" {
  value = aws_s3_bucket.builds_bucket.arn
  description = "Arn of the s3 bucket containing the builds"
}
