#ALB security group, only allow http/https from the internet
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "enable http/https traffic to alb"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "outbound traffic to ecs tasks"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}


#ECS security group, only accepts traffic from the ALB
resource "aws_security_group" "ecs-tasks" {
  name        = "${var.project_name}-ecs-tasks-sg"
  description = "security group for ecs tasks"
  vpc_id      = var.vpc_id

  ingress {
    description     = "inbound traffic from alb to dashboard ecs task"
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]

  }

  ingress {
    description     = "inbound traffic from alb to api ecs task"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]

  }

  egress {
    description = "outbound traffic to rds, redis and vpc endpoint"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-tasks-sg"
  }
}


#RDS security group, only allows database connections from ECS tasks
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "security group for rds database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "inbound traffic from ecs task to rds database"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs-tasks.id]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

#Redis security group, only allows traffic in from ecs tasks
resource "aws_security_group" "redis" {
  name        = "${var.project_name}-redis-sg"
  description = "security group for redis"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow redis access from ecs task"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs-tasks.id]
  }

  tags = {
    Name = "${var.project_name}-redis-sg"
  }
}

#vpc endpoint security group to allow https traffic from ecs task, controls what traffic is allowed to reach the endpoints elastic network interface (eni), https as the communication needs to be encrypted in transit.
resource "aws_security_group" "vpce" {
  name        = "${var.project_name}-vpce-sg"
  description = "security group for vpc endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description     = "enable https traffic from ecs task to vpc endpoint"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs-tasks.id]
  }

  tags = {
    Name = "${var.project_name}-vpce-sg"
  }

}