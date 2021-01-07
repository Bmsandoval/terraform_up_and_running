release steps:
* apply the "remote_state" folder
* apply the "builds_bucket" folder
* apply the "load_balancer" folder
* apply the "codepipeline" folder

these steps should be destroyed when finished:
* apply the top-level folder






Adding a new project to terraform:
You will need a full codepipeline with it's own s3 bucket for each project