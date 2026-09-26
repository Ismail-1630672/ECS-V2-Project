data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "alias_a_records" {
  for_each = toset(var.host_names)
  zone_id  = data.aws_route53_zone.hosted_zone.id
  type     = "A"
  name     = each.value

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

}