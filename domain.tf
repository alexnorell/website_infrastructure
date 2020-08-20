resource "aws_route53_zone" "norell_dev" {
  name = "norell.dev"
}

resource "aws_route53_record" "norell_dev" {
  zone_id = aws_route53_zone.norell_dev.zone_id
  name    = "www.norell.dev"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.website.website_endpoint
    zone_id                = aws_s3_bucket.website.hosted_zone_id
    evaluate_target_health = true
  }
}