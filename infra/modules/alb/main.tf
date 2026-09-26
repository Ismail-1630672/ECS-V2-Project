resource "aws_lb" "alb" {
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_id
  internal           = false
  name               = "${var.project_name}-alb"

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "blue-prod-api" {
  name        = "${var.project_name}-blue-prod-api-tg"
  target_type = var.target_type
  vpc_id      = var.vpc_id
  port        = var.api_port
  protocol    = var.protocol


  health_check {
    enabled             = true
    path                = "/healthz"
    port                = var.api_port
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-299"
  }

}

resource "aws_lb_target_group" "green-test-api" {
  name        = "${var.project_name}-green-test-api-tg"
  target_type = var.target_type
  vpc_id      = var.vpc_id
  port        = var.api_port
  protocol    = var.protocol

  health_check {
    enabled             = true
    path                = "/healthz"
    port                = var.api_port
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-299"
  }

}

resource "aws_lb_target_group" "blue-prod-dashboard" {
  name        = "${var.project_name}-blue-prod-dashboard"
  target_type = var.target_type
  vpc_id      = var.vpc_id
  port        = var.dashboard_port
  protocol    = var.protocol

  health_check {
    enabled             = true
    path                = "/healthz"
    port                = var.dashboard_port
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-299"
  }

}

resource "aws_lb_target_group" "green-test-dashboard" {
  name        = "${var.project_name}-green-test-dashboard"
  target_type = var.target_type
  vpc_id      = var.vpc_id
  port        = var.dashboard_port
  protocol    = var.protocol

  health_check {
    enabled             = true
    path                = "/healthz"
    port                = var.dashboard_port
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-299"
  }

}

resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = var.protocol

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found, does not match either listener rule"
      status_code  = "404"
    }
  }


}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue-prod-api.arn
  }

  condition {
    host_header {
      values = ["api.ecs.ismail-osman.co.uk"]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}

resource "aws_lb_listener_rule" "dashboard" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue-prod-dashboard.arn
  }

  condition {
    host_header {
      values = ["dashboard.ecs.ismail-osman.co.uk"]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}