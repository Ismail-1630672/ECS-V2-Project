variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "eu-west-2"
}

variable "project_name" {
  type        = string
  description = "name of project"
  default     = "ecs-v2"
}


variable "vpc_cidr" {
  type        = string
  description = "The IP address range for my VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "list of availability zones"
  default     = ["eu-west-2a", "eu-west-2b"]

}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "cidr blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "cidr blocks for private subnets"
  default     = ["10.0.100.0/24", "10.0.200.0/24"]
}

variable "interface_endpoint_services" {
  type        = map(string)
  description = "interface endpoints for various services"
  default = {
    ecr_api               = "com.amazonaws.eu-west-2.ecr.api"
    ecr_dkr               = "com.amazonaws.eu-west-2.ecr.dkr"
    cloudwatch_logs       = "com.amazonaws.eu-west-2.logs"
    cloudwatch_monitoring = "com.amazonaws.eu-west-2.monitoring"
    sqs_ques              = "com.amazonaws.eu-west-2.sqs"
    secrets_manager       = "com.amazonaws.eu-west-2.secretsmanager"
  }
}

variable "load_balancer_type" {
  type        = string
  description = "type of application load balaner"
  default     = "application"
}

variable "target_type" {
  type        = string
  description = "type of target group either IP (ecs tasks) or instance (ec2)"
  default     = "ip"
}

variable "api_port" {
  type        = number
  description = "port number for api microservice"
  default     = 8080
}

variable "dashboard_port" {
  type        = number
  description = "port number for dashboard microservice"
  default     = 8081
}

variable "protocol" {
  type        = string
  description = "protocol alb uses to communicate with ecs tasks inside vpc once https is decrypted"
  default     = "HTTP"
}

variable "domain_name" {
  type        = string
  description = "name of my domain"
  default     = "ecs.ismail-osman.co.uk"
}

variable "validation_method" {
  type        = string
  description = "method to tell acm that I control the domain for which I am requesting the certificate for"
  default     = "DNS"
}

variable "host_names" {
  type        = list(string)
  description = "a list of my host names for each request based microservice"
  default     = ["api.ecs.ismail-osman.co.uk", "dashboard.ecs.ismail-osman.co.uk"]
}

variable "engine_version" {
  type        = string
  description = "version of postgresql engine"
  default     = "18.4"
}

variable "instance_class" {
  type        = string
  description = "compute capacity of machine running postgredql database primarily the cpu and memory"
  default     = "db.t4g.micro"
}

variable "db_name" {
  type        = string
  description = "Name of database"
  default     = "postgresqldatabase"
}

variable "db_username" {
  type        = string
  description = "username for database"
  default     = "ismaildatabase"
}

variable "message_retention" {
  type        = number
  description = "number of days failed messages should be kept for"
  default     = 1209600
}

variable "microservices_logs" {
  type        = list(string)
  description = "list of microservices for logs"
  default     = ["api", "dashboard", "worker"]
}

variable "cpu" {
  type        = number
  description = "cpu allocated to ecs task"
  default     = 256
}

variable "memory" {
  type        = number
  description = "memory allocated to ecs task"
  default     = 512
}

variable "desired_count" {
  type        = number
  description = "desired count for ecs tasks"
  default     = 2
}
