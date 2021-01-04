output "builds_s3_bucket_arn" {
  value = aws_s3_bucket.builds_bucket.arn
  description = "ARN of the s3 bucket containing the builds"
}