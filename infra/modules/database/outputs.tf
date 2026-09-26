output "db_endpoint" {
  description = "postgres sql connection endpoint"
  value       = aws_db_instance.db-instance.endpoint
}

output "credentials_secret_arn" {
  description = "ARN of the secret managers secret"
  value       = aws_secretsmanager_secret.database-password.arn
}

