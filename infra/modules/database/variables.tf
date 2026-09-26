variable "project_name" {
  type        = string
  description = "name of project"
}

variable "private_subnet_id" {
}

variable "engine_version" {
  type        = string
  description = "version of postgresql engine"
}

variable "instance_class" {
  type        = string
  description = "compute capacity of machine running postgredql database primarily the cpu and memory"
}

variable "db_name" {
  type        = string
  description = "Name of database"
}

variable "db_username" {
  type        = string
  description = "username for database"
}

variable "rds_security_group_id" {
}

