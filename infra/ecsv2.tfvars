aws_region = "eu-west-2"


project_name = "ecs-v2"



vpc_cidr = "10.0.0.0/16"


availability_zones = ["eu-west-2a", "eu-west-2b"]



public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]



private_subnet_cidr_blocks = ["10.0.100.0/24", "10.0.200.0/24"]


interface_endpoint_services = {
  ecr_api               = "com.amazonaws.eu-west-2.ecr.api"
  ecr_dkr               = "com.amazonaws.eu-west-2.ecr.dkr"
  cloudwatch_logs       = "com.amazonaws.eu-west-2.logs"
  cloudwatch_monitoring = "com.amazonaws.eu-west-2.monitoring"
  sqs_ques              = "com.amazonaws.eu-west-2.sqs"
  secrets_manager       = "com.amazonaws.eu-west-2.secretsmanager"
}


load_balancer_type = "application"


target_type = "ip"


api_port = 8080


dashboard_port = 8081


protocol = "HTTP"


domain_name = "ecs.ismail-osman.co.uk"


validation_method = "DNS"


host_names = ["api.ecs.ismail-osman.co.uk", "dashboard.ecs.ismail-osman.co.uk"]


engine_version = "18.4"


instance_class = "db.t4g.micro"


db_name = "postgresqldatabase"


db_username = "ismaildatabase"


message_retention = 1209600


microservices_logs = ["api", "dashboard", "worker"]


cpu = 256


memory = 512


desired_count = 2

