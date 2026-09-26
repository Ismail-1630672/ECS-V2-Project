output "vpc_id" {
  description = "the id of my vpc"
  value       = aws_vpc.main-vpc.id
}

output "public_subnet_id" {
  description = "id of public subnet"
  value       = aws_subnet.public-subnet[*].id
}

output "private_subnet_id" {
  description = "id of private subnet"
  value       = aws_subnet.private-subnet[*].id
}

output "internet_gateway_id" {
  description = "id of internet gateway"
  value       = aws_internet_gateway.internet-gateway.id
}

output "public_route_table_id" {
  description = "id of public route table"
  value       = aws_route_table.public-rt.id
}

output "private_route_table_id" {
  description = "id of private route table"
  value       = aws_route_table.private-rt.id
}