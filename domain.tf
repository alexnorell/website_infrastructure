variable "domain_name" {
  description = "domain name to use from route53"
  default     = "norell.dev"
}

variable "subdomain" {
  description = "subdomain to create record and bucket for"
  default     = "www"
}

data "aws_route53_zone" "domain" {
  name = var.domain_name
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${var.subdomain}.${data.aws_route53_zone.domain.name}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.website.website_domain
    zone_id                = aws_s3_bucket.website.hosted_zone_id
    evaluate_target_health = true
  }
}