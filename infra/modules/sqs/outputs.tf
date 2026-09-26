output "sqs_queue_url" {
  value = aws_sqs_queue.main_queue.url
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.dlq.arn
}