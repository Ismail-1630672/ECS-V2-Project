variable "vpc_id" {
}

variable "project_name" {
  type        = string
  description = "name of project"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "private_route_table_id" {
}

variable "interface_endpoint_services" {
  type        = map(string)
  description = "interface endpoints for various services"
}

variable "private_subnet_id" {
}

variable "vpce_security_group_id" {
}