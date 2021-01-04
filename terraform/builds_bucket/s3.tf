resource "aws_s3_bucket" "builds_bucket" {
  bucket = "${local.environment}-${local.company}-builds-bucket"

  tags = {
    Environment = local.environment
  }
}