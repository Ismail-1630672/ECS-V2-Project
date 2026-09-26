output "load_balancer_arn" {
  value = aws_lb.alb.arn
}

output "listener_arn" {
  value = aws_lb_listener.https.arn
}

output "api_target_group_arn" {
  value = aws_lb_target_group.blue-prod-api.arn
}

output "dashboard_target_group_arn" {
  value = aws_lb_target_group.blue-prod-dashboard.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "blue_api_target_group_name" {
  value = aws_lb_target_group.blue-prod-api.name
}

output "green_api_target_group_name" {
  value = aws_lb_target_group.green-test-api.name
}

output "blue_dashboard_target_group_name" {
  value = aws_lb_target_group.blue-prod-dashboard.name
}

output "green_dashboard_target_group_name" {
  value = aws_lb_target_group.green-test-dashboard.name
}