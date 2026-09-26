data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

#execution role 
resource "aws_iam_role" "execution" {
  name               = "${var.project_name}-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "secrets_access" {
  name = "${var.project_name}-ecs-secrets-access"
  role = aws_iam_role.execution.id


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["secretsmanager:GetSecretValue"]

        Resource = [var.credentials_secret_arn]

    }]
  })
}

#task role 
resource "aws_iam_role" "api_task_role" {
  name               = "${var.project_name}-api-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

#Allow API microservice to send messages to sqs
resource "aws_iam_policy" "api_policy" {
  name        = "${var.project_name}-api-policy"
  description = "policy which allows api microservice to send messages to sqs queue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage", "sqs:GetQueueUrl", "sqs:SendMessageBatch"]
        Resource = [var.sqs_queue_arn]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_task_policy" {
  role       = aws_iam_role.api_task_role.name
  policy_arn = aws_iam_policy.api_policy.arn
}

resource "aws_iam_role" "worker_task_role" {
  name               = "${var.project_name}-worker-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

}

#Allow worker microservice to consume messages from sqs
resource "aws_iam_policy" "worker_policy" {
  name        = "${var.project_name}-worker-policy"
  description = "policy which allows worker microservice to receive messages from sqs queue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueUrl", "sqs:GetQueueAttributes", "sqs:ChangeMessageVisibility"]
        Resource = [var.sqs_queue_arn]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_task_policy" {
  role       = aws_iam_role.worker_task_role.name
  policy_arn = aws_iam_policy.worker_policy.arn
}

#Dashboard task role
resource "aws_iam_role" "dashboard_task_role" {
  name               = "${var.project_name}-dashboard-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

#IAM Role for codedeploy
resource "aws_iam_role" "codedeploy_role" {
  name = "${var.project_name}-codedeploy-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}




