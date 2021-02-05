variable "aws_region" {
  type = string
}

variable "server_port" {
  type = string
}
variable "application_name" {
  type = string
  description = "name of application using codepipeline"
}
variable "company_name" {
  type = string
  description = "current company name (option included for easier pivots/name changes)"
}
