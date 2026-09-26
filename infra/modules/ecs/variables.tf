variable "project_name" {
  description = "name of project"
  type        = string
}

variable "microservices_logs" {
  type        = list(string)
  description = "list of microservices for logs"
}

variable "cpu" {
  type        = number
  description = "cpu allocated to ecs task"
}

variable "memory" {
  type        = number
  description = "memory allocated to ecs task"
}

variable "api_port" {
  type        = number
  description = "port number for api microservice"
}

variable "dashboard_port" {
  type        = number
  description = "port number of dashboard microservice"
}


variable "sqs_queue_url" {
  type        = string
  description = "The URL of the created amazon sqs queue"
}

variable "credentials_secret_arn" {
  type        = string
  description = "arn of the secret manager secret containing the postgreSQL database connection URL"
}

variable "desired_count" {
  type        = number
  description = "desired count for ecs tasks"
}

variable "private_subnet_id" {
}

variable "ecs_security_group_id" {
}

variable "api_target_group_arn" {
}

variable "dashboard_target_group_arn" {
}

variable "execution_role_arn" {
}

variable "api_task_role_arn" {
}

variable "worker_task_role_arn" {
}

variable "dashboard_task_role_arn" {
}