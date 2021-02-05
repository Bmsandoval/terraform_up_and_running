resource "aws_s3_bucket" "codebuild_bucket" {
  bucket = "${local.environment}-${local.pipeline_project_name}-codepipeline-cache-${data.aws_caller_identity.current.account_id}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      lifecycle_rule
    ]
  }
}