resource "aws_wafv2_web_acl" "container" {
    name = "${var.project_name}-waf-container"
    scope = "REGIONAL"

    default_action {
        allow {}
    }

    rule {
        name = "aws-managed-common-rules"
        priority = 10

        override_action {
            none {}
        }

        statement {
            managed_rule_group_statement {
                name = "AWSManagedRulesCommonRuleSet"
                vendor_name = "AWS"
            }
        }

        visibility_config {
            cloudwatch_metrics_enabled = true 
            metric_name = "${var.project_name}-CommonRuleMetrics"
            sample_requests_enabled = true 
        }
    }

    rule {
        name = "aws-managed-sql-injection"
        priority = 20 

        override_action {
            none {}
        }

        statement {
            managed_rule_group_statement {
                name = "AWSManagedRulesSQLiRuleSet"
                vendor = "AWS"
            }
        }

        visibility_config {
            cloudwatch_metrics_enabled = true 
            metric_name = "${var.project_name}-SQLInjectionMetrics"
            sample_requests_enabled = true 
        }
    }

    rule {
        name = "aws-managed-known-bad-inputs"
        priority = 30 

        override_action {
            none {}
        }

        statement {
            managed_rule_group_statement {
                name = "AWSManagedRulesKnownBadInputsRuleSet"
                vendor = "AWS"
            }
        }

        visibility_config {
            cloudwatch_metrics_enabled = true 
            metric_name = "${var.project_name}-KnownBadInputMetrics"
            sample_requests_enabled = true 
        }
    }

    rule {
        name = "aws-managed-bot-control"
        priority = 40 

        override_action {
            none {}
        }

        statement {
            managed_rule_group_statement {
                name = "AWSManagedRulesBotControlRuleSet"
                vendor = "AWS"
            }
        }

        visibility_config {
            cloudwatch_metrics_enabled = true 
            metric_name = "${var.project_name}-BotControlMetrics"
            sample_requests_enabled = true 
        }
    }

    visibility_config {
        cloudwatch_metrics_enabled = true 
        metric_name = "${var.project_name}-waf-metrics"
        sample_requests_enabled = true 
    }
}

resource "aws_wafv2_web_acl_association" "alb" {
    resource_arn = var.load_balancer_arn
    web_acl_arn = aws_wafv2_web_acl.container.arn 
}