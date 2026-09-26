#S3 gateway endpoint
resource "aws_vpc_endpoint" "S3" {
  vpc_id          = var.vpc_id
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [var.private_route_table_id]

  tags = {
    Name = "${var.project_name}-s3-gateway-endpoint"
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each            = var.interface_endpoint_services
  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.private_subnet_id
  security_group_ids  = [var.vpce_security_group_id]

  tags = {
    Name = "${var.project_name}-${each.key}-endpoint"
  }


}