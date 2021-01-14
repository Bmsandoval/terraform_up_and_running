variable "github_repo_owner" {
  type = "string"
  description = "owner of the github repo that this pipeline is watching"
}

variable "github_repo_name" {
  type = "string"
  description = "name of the repo that this pipeline is watching"
}

variable "github_branch" {
  type = "string"
  description = "name of the branch that this pipeline is watching (likely 'master' or 'trunk')"
}

variable "github_token" {
  type = "string"
  description = "github personal access token. used by codepipeline to hook into github."
}
