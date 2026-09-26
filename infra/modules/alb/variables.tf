variable "load_balancer_type" {
  type        = string
  description = "type of application load balaner"
}

variable "project_name" {
  type        = string
  description = "name of project"
}

variable "alb_security_group_id" {
}

variable "public_subnet_id" {
}

variable "target_type" {
  type        = string
  description = "type of target group either IP (ecs tasks) or instance (ec2)"
}

variable "vpc_id" {
}

variable "api_port" {
  type        = number
  description = "port number for api microservice"
}

variable "dashboard_port" {
  type        = number
  description = "port number for dashboard microservice"
}

variable "protocol" {
  type        = string
  description = "protocol alb uses to communicate with ecs tasks inside vpc once https is decrypted"
}

variable "certificate_arn" {
}