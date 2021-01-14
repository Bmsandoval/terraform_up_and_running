resource "aws_codepipeline" "pipeline" {
  name     = "${local.environment}-${local.pipeline_project_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codebuild_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      category         = "Source"
      name             = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_repo_owner
        Repo       = var.github_repo_name
        Branch     = var.github_branch
        OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }

//  dynamic "stage" {
//    for_each = local.has_deploy_stage ? [1] : []
//    content {
//      name = "Deploy"
//      action {
//        category        = "Deploy"
//        name            = "Deploy"
//        owner           = "AWS"
//        provider        = var.deploy_provider
//        version         = "1"
//        input_artifacts = ["build_output"]
//
//        configuration = var.deploy_configuration
//      }
//    }
//  }
//
//  lifecycle {
//    ignore_changes = [
//      stage[0].action[0].configuration // ignore GitHub's OAuthToken
//    ]
//  }
}





resource "aws_codebuild_project" "build_project" {
  name         = "${local.environment}-${local.pipeline_project_name}-Build"
  service_role = aws_iam_role.codepipeline_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:3.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
  }
  cache {
    type     = "S3"
    location = "${aws_s3_bucket.codebuild_bucket.bucket}/cache"
  }
  source {
    type      = "CODEPIPELINE"
    git_clone_depth = "25"
    buildspec = "buildspec.yml"
  }
}