resource "aws_codedeploy_app" "blue_green_app" {
  name             = "blue-green-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "api_deployment_group" {
  app_name               = aws_codedeploy_app.blue_green_app.name
  deployment_group_name  = "api-blue-green-deployment-group"
  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"
  service_role_arn       = var.codedeploy_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  #deployment configuration for creation of new green ecs tasks and termination of old blue tasks
  blue_green_deployment_config {

    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.api_ecs_service_name
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_arn]
      }

      target_group {
        name = var.blue_api_target_group_name
      }

      target_group {
        name = var.green_api_target_group_name
      }
    }
  }



}

resource "aws_codedeploy_deployment_group" "dashboard_deployment_group" {
  app_name               = aws_codedeploy_app.blue_green_app.name
  deployment_group_name  = "dashboard-blue-green-deployment-group"
  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"
  service_role_arn       = var.codedeploy_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  #deployment configuration for creation of new green ecs tasks and termination of old blue tasks
  blue_green_deployment_config {

    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.dashboard_ecs_service_name
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_arn]
      }

      target_group {
        name = var.blue_dashboard_target_group_name
      }

      target_group {
        name = var.green_dashboard_target_group_name
      }
    }
  }



}