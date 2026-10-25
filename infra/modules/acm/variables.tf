variable "domain_name" {
  type        = string
  description = "name of my domain"
}

variable "validation_method" {
  type        = string
  description = "method to tell acm that I control the domain for which I am requesting the certificate for"
}

variable "project_name" {
  type        = string
  description = "name of project"
}

variable "wildcard_domain_name" {
  type        = string
  descriptipn = "wildcard domain name"
}