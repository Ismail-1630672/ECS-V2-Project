output "execution_role_arn" {
  value = aws_iam_role.execution.arn
}

output "api_task_role_arn" {
  value = aws_iam_role.api_task_role.arn
}

output "worker_task_role_arn" {
  value = aws_iam_role.worker_task_role.arn
}

output "dashboard_task_role_arn" {
  value = aws_iam_role.dashboard_task_role.arn
}

output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}