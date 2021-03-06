variable "domain_name" {
  description = "top level domain name to use from Route53. Must be a hosted zone in Route53. example: example.com"
}

variable "subdomain" {
  description = "subdomain to create record and bucket for. example: wwww"
}

locals {
  full_domain = "${var.subdomain}.${var.domain_name}"
}

data "aws_route53_zone" "domain" {
  name = var.domain_name
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = local.full_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.domain_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.domain_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
