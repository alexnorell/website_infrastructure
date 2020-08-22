variable "domain_name" {
  description = "domain name to use from route53"
  default     = "norell.dev"
}

variable "subdomain" {
  description = "subdomain to create record and bucket for"
  default     = "www"
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

resource "aws_route53_record" "www_validation" {
  for_each = {
    for dvo in aws_acm_certificate.www.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain.zone_id
}


resource "aws_acm_certificate" "www" {
  provider          = aws.us_east_1
  domain_name       = local.full_domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "www" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.www.arn
  validation_record_fqdns = [for record in aws_route53_record.www_validation : record.fqdn]
}

