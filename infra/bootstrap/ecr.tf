resource "aws_ecr_repository" "microservices" {
  for_each     = var.microservices
  force_delete = true

  name                 = each.value
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

}