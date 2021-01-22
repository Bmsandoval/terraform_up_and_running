release steps:

do these steps once and only once:
* apply the "remote_state" folder
* apply the "database" folder

these steps don't cost much, they can stick around if you want:
* apply the "builds_bucket" folder
* apply the "load_balancer" folder
* apply the "codepipeline" folder

these steps should be destroyed regularly to save money:
* apply the top-level folder






Adding a new project to terraform:
You will need a full codepipeline with it's own s3 bucket for each project