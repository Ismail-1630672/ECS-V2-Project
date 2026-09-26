resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "microservices" {
  for_each = toset(var.microservices_logs)

  name              = "/ecs/${var.project_name}/${each.value}"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-${each.value}-logs"
  }
}



data "aws_ecr_repository" "api" {
  name = "api-repo"
}

resource "aws_ecs_task_definition" "api-task" {
  family                   = "${var.project_name}-api-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.api_task_role_arn

  container_definitions = jsonencode([{
    name      = "${var.project_name}-api-container"
    image     = "${data.aws_ecr_repository.api.repository_url}:latest"
    essential = true

    portMappings = [{
      containerPort = var.api_port
      protocol      = "tcp"
    }]

    environment = [

      {
        name  = "SQS_QUEUE_URL"
        value = var.sqs_queue_url
    }]

    secrets = [
      {
        name      = "DATABASE_URL"
        valueFrom = var.credentials_secret_arn
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.microservices["api"].name
        "awslogs-region"        = "eu-west-2"
        "awslogs-stream-prefix" = "api"
      }
    }
  }])

  tags = {
    Name = "${var.project_name}-api-task-definition"
  }

}

resource "aws_ecs_service" "api_service" {
  name            = "${var.project_name}-api-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.api-task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets         = var.private_subnet_id
    security_groups = [var.ecs_security_group_id]
  }

  force_new_deployment = true
  load_balancer {
    target_group_arn = var.api_target_group_arn
    container_name   = "${var.project_name}-api-container"
    container_port   = 8080
  }

  #ignore changes in ecs service task definition and load balancer configuration as code deploy will handle this
  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}

data "aws_ecr_repository" "worker" {
  name = "worker-repo"
}

resource "aws_ecs_task_definition" "worker-task" {
  family                   = "${var.project_name}-worker-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.worker_task_role_arn

  container_definitions = jsonencode([{
    name      = "${var.project_name}-worker-container"
    image     = "${data.aws_ecr_repository.worker.repository_url}:latest"
    essential = true



    environment = [

      {
        name  = "SQS_QUEUE_URL"
        value = var.sqs_queue_url
    }]

    secrets = [
      {
        name      = "DATABASE_URL"
        valueFrom = var.credentials_secret_arn
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.microservices["worker"].name
        "awslogs-region"        = "eu-west-2"
        "awslogs-stream-prefix" = "worker"
      }
    }
  }])

  tags = {
    Name = "${var.project_name}-worker-task-definition"
  }

}

resource "aws_ecs_service" "worker_service" {
  name            = "${var.project_name}-worker-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.worker-task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_id
    security_groups = [var.ecs_security_group_id]
  }

}

data "aws_ecr_repository" "dashboard" {
  name = "dashboard-repo"
}

resource "aws_ecs_task_definition" "dashboard-task" {
  family                   = "${var.project_name}-dashboard-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.dashboard_task_role_arn

  container_definitions = jsonencode([{
    name      = "${var.project_name}-dashboard-container"
    image     = "${data.aws_ecr_repository.dashboard.repository_url}:latest"
    essential = true

    portMappings = [{
      containerPort = var.dashboard_port
      protocol      = "tcp"
    }]



    secrets = [
      {
        name      = "DATABASE_URL"
        valueFrom = var.credentials_secret_arn
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.microservices["dashboard"].name
        "awslogs-region"        = "eu-west-2"
        "awslogs-stream-prefix" = "dashboard"
      }
    }
  }])

  tags = {
    Name = "${var.project_name}-dashboard-task-definition"
  }

}

resource "aws_ecs_service" "dashboard_service" {
  name            = "${var.project_name}-dashboard-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.dashboard-task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets         = var.private_subnet_id
    security_groups = [var.ecs_security_group_id]
  }

  force_new_deployment = true
  load_balancer {
    target_group_arn = var.dashboard_target_group_arn
    container_name   = "${var.project_name}-dashboard-container"
    container_port   = 8081
  }

  #ignore changes in ecs service task definition and load balancer configuration as code deploy will handle this
  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}


