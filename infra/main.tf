module "vpc" {
  source                     = "./modules/vpc"
  project_name               = var.project_name
  vpc_cidr                   = var.vpc_cidr
  availability_zones         = var.availability_zones
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks


}

module "security-groups" {
  source       = "./modules/security-groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id

}

module "vpc-endpoints" {
  source                      = "./modules/vpc-endpoints"
  project_name                = var.project_name
  aws_region                  = var.aws_region
  vpc_id                      = module.vpc.vpc_id
  private_route_table_id      = module.vpc.private_route_table_id
  interface_endpoint_services = var.interface_endpoint_services
  private_subnet_id           = module.vpc.private_subnet_id
  vpce_security_group_id      = module.security-groups.vpce_security_group_id
}


module "acm" {
  source            = "./modules/acm"
  domain_name       = var.domain_name
  validation_method = var.validation_method
  project_name      = var.project_name
}


module "alb" {
  source                = "./modules/alb"
  project_name          = var.project_name
  load_balancer_type    = var.load_balancer_type
  alb_security_group_id = module.security-groups.alb_security_group_id
  public_subnet_id      = module.vpc.public_subnet_id
  target_type           = var.target_type
  vpc_id                = module.vpc.vpc_id
  api_port              = var.api_port
  dashboard_port        = var.dashboard_port
  protocol              = var.protocol
  certificate_arn       = module.acm.certificate_arn

}


module "route53" {
  source       = "./modules/route53"
  domain_name  = var.domain_name
  host_names   = var.host_names
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "database" {
  source                = "./modules/database"
  project_name          = var.project_name
  private_subnet_id     = module.vpc.private_subnet_id
  instance_class        = var.instance_class
  db_name               = var.db_name
  db_username           = var.db_username
  rds_security_group_id = module.security-groups.rds_security_group_id
  engine_version        = var.engine_version
}

module "redis" {
  source                  = "./modules/redis"
  project_name            = var.project_name
  private_subnet_id       = module.vpc.private_subnet_id
  redis_security_group_id = module.security-groups.rds_security_group_id
}

module "sqs" {
  source            = "./modules/sqs"
  project_name      = var.project_name
  message_retention = var.message_retention
}

module "ecs" {
  source                     = "./modules/ecs"
  project_name               = var.project_name
  microservices_logs         = var.microservices_logs
  cpu                        = var.cpu
  memory                     = var.memory
  api_port                   = var.api_port
  dashboard_port             = var.dashboard_port
  credentials_secret_arn     = module.database.credentials_secret_arn
  sqs_queue_url              = module.sqs.sqs_queue_url
  private_subnet_id          = module.vpc.private_subnet_id
  ecs_security_group_id      = module.security-groups.ecs_security_group_id
  api_target_group_arn       = module.alb.api_target_group_arn
  dashboard_target_group_arn = module.alb.dashboard_target_group_arn
  desired_count              = var.desired_count
  execution_role_arn         = module.iam.execution_role_arn
  api_task_role_arn          = module.iam.api_task_role_arn
  worker_task_role_arn       = module.iam.worker_task_role_arn
  dashboard_task_role_arn    = module.iam.dashboard_task_role_arn

}

module "iam" {
  source                 = "./modules/iam"
  project_name           = var.project_name
  credentials_secret_arn = module.database.credentials_secret_arn
  sqs_queue_arn          = module.sqs.sqs_queue_arn

}

module "codedeploy" {
  source                            = "./modules/codedeploy"
  codedeploy_role_arn               = module.iam.codedeploy_role_arn
  ecs_cluster_name                  = module.ecs.ecs_cluster_name
  api_ecs_service_name              = module.ecs.api_ecs_service_name
  dashboard_ecs_service_name        = module.ecs.dashboard_ecs_service_name
  listener_arn                      = module.alb.listener_arn
  blue_api_target_group_name        = module.alb.blue_api_target_group_name
  green_api_target_group_name       = module.alb.green_api_target_group_name
  blue_dashboard_target_group_name  = module.alb.blue_dashboard_target_group_name
  green_dashboard_target_group_name = module.alb.green_dashboard_target_group_name
}

module "waf" {
  source            = "./modules/waf"
  project_name      = var.project_name
  load_balancer_arn = module.alb.load_balancer_arn

}
