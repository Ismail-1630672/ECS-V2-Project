resource "aws_vpc" "main-vpc" {
  cidr_block           = var.vpc_cidr # define IP address range for vpc
  enable_dns_support   = true         #enables domain names to be converted into ip addresses
  enable_dns_hostnames = true         #gives domain names to applicable resources inside vpc

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index] #index into cidr list
  availability_zone = var.availability_zones[count.index]        #index into az list

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private-subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.project_name}-internet-gateway"
  }
}

#route tables to define where traffic is directed
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }

  depends_on = [aws_vpc.main-vpc]


}

#Route table association will ensure clean isolation between public and private networks
resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.project_name}-private-route-table"
  }

  depends_on = [aws_vpc.main-vpc]
}

resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-rt.id
}