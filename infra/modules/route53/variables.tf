variable "domain_name" {
  type        = string
  description = "name of my domain"
}

variable "host_names" {
  type        = list(string)
  description = "a list of my host names for each request based microservice"
}

variable "alb_dns_name" {
}

variable "alb_zone_id" {
}