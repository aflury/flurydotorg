resource "aws_acm_certificate" "flurydotorg" {
  domain_name       = var.domain
  validation_method = "DNS"
  subject_alternative_names = [
    "chat.${var.domain}",
    "linkedin.${var.domain}",
    "message.${var.domain}",
    "resume.${var.domain}",
    "www.${var.domain}",
    "xn--rsum-bpad.${var.domain}"
  ]
}

resource "aws_acm_certificate_validation" "flurydotorg" {
  certificate_arn         = aws_acm_certificate.flurydotorg.arn
  validation_record_fqdns = [for record in cloudflare_record.validate_tls : record.hostname]
}

