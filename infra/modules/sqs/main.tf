# dead-letter queue for failed messages
resource "aws_sqs_queue" "dlq" {
  name = "${var.project_name}-failed-messages"

  message_retention_seconds = var.message_retention
  tags = {
    Name = "${var.project_name}-failed-messages"
  }
}

resource "aws_sqs_queue" "main_queue" {
  name = "${var.project_name}-main-queue"

  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 20


  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "${var.project_name}-main-queue"
  }
}