variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "project_name" {
  type    = string
  default = "ecs-v2"
}



variable "s3_bucket_name" {
  type    = string
  default = "ismail-osman-ecs-v2-bucket"

}


variable "microservices" {
  type = set(string)
  default = [
    "api-repo",
    "worker-repo",
    "dashboard-repo"
  ]

}