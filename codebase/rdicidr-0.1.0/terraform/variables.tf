# In this file put the variables related to the deployment
variable "aws_region" {
    type = string
    description = "Description"
    default = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type = string
  default = "fs1-devops-challange"
}

variable "environment" {
    description = "Development environment"
    type  = string
    default = "devel"
}