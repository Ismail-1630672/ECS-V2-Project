variable "vpc_cidr" {
  type        = string
  description = "The IP address range for my VPC"
}

variable "project_name" {
  type        = string
  description = "name of project"
}

variable "availability_zones" {
  type        = list(string)
  description = "list of availability zones"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "cidr blocks for public subnets"

}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "cidr blocks for private subnets"
}