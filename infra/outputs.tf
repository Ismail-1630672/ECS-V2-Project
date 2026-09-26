output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "public_route_table_id" {
  value = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  value = module.vpc.private_route_table_id
}

output "alb_security_group_id" {
  value = module.security-groups.alb_security_group_id
}

output "ecs_security_group_id" {
  value = module.security-groups.ecs_security_group_id
}

output "vpce_security_group_id" {
  value = module.security-groups.vpce_security_group_id
}

output "rds_security_group_id" {
  value = module.security-groups.rds_security_group_id
}

output "load_balancer_arn" {
  value = module.alb.load_balancer_arn
}

output "listener_arn" {
  value = module.alb.listener_arn
}

output "api_target_group_arn" {
  value = module.alb.api_target_group_arn
}

output "dashboard_target_group_arn" {
  value = module.alb.dashboard_target_group_arn
}

output "certificate_arn" {
  value = module.acm.certificate_arn
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_zone_id" {
  value = module.alb.alb_zone_id
}

output "db_endpoint" {
  value = module.database.db_endpoint
}

output "credentials_secret_arn" {
  value = module.database.credentials_secret_arn
}

output "sqs_queue_url" {
  value = module.sqs.sqs_queue_url
}

output "execution_role_arn" {
  value = module.iam.execution_role_arn
}

output "api_task_role_arn" {
  value = module.iam.api_task_role_arn
}

output "worker_task_role_arn" {
  value = module.iam.worker_task_role_arn
}

output "dashboard_task_role_arn" {
  value = module.iam.dashboard_task_role_arn
}

output "codedeploy_role_arn" {
  value = module.iam.codedeploy_role_arn
}

output "sqs_queue_arn" {
  value = module.sqs.sqs_queue_arn
}

output "ecs_cluster_name" {
  value = module.ecs.ecs_cluster_name
}

output "api_ecs_service_name" {
  value = module.ecs.api_ecs_service_name
}

output "dashboard_ecs_service_name" {
  value = module.ecs.dashboard_ecs_service_name
}

output "blue_api_target_group_name" {
  value = module.alb.blue_api_target_group_name
}

output "green_api_target_group_name" {
  value = module.alb.green_api_target_group_name
}

output "blue_dashboard_target_group_name" {
  value = module.alb.blue_dashboard_target_group_name
}

output "green_dashboard_target_group_name" {
  value = module.alb.green_dashboard_target_group_name
}