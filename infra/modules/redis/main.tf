resource "aws_elasticache_subnet_group" "redis-subnet" {
  name       = "${var.project_name}-redis-subnet"
  subnet_ids = var.private_subnet_id

  tags = {
    Name = "${var.project_name}-redis-subnet"
  }

}

resource "aws_elasticache_cluster" "redis-cluster" {
  cluster_id           = "${var.project_name}-redis-cluster"
  engine               = "redis"
  engine_version       = "7.1"
  node_type            = "cache.t4g.micro"
  num_cache_nodes      = 1
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis-subnet.name
  security_group_ids   = [var.redis_security_group_id]
  parameter_group_name = "default.redis7"

  tags = {
    Name = "${var.project_name}-redis-cluster"
  }
}