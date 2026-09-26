output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "api_ecs_service_name" {
  value = aws_ecs_service.api_service.name
}

output "dashboard_ecs_service_name" {
  value = aws_ecs_service.dashboard_service.name
}