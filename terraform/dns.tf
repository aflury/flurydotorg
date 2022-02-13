resource "cloudflare_zone" "flurydotorg" {
  zone = var.domain
}

resource "cloudflare_record" "flurydotorg" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "${var.domain}."
  value   = aws_lb.flurydotorg.dns_name
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "www"
  value   = var.domain
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "linkedin" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "linkedin"
  value   = var.domain
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "chat" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "chat"
  value   = var.domain
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "source" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "source"
  value   = var.domain
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "message" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "message"
  value   = var.domain
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "resume" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "resume"
  value   = var.domain
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "resume_" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "xn--rsum-bpad"
  value   = var.domain
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "address" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "ec2"
  value   = aws_eip.flurydotorg.public_ip
  type    = "A"
  proxied = false
  ttl     = 300
}

resource "cloudflare_record" "mx" {
  zone_id  = cloudflare_zone.flurydotorg.id
  name     = "${var.domain}."
  value    = "${var.symbolic_name}.mail.protection.outlook.com"
  type     = "MX"
  priority = 10
  proxied  = false
  ttl      = 300
}

resource "cloudflare_record" "autodiscover" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "autodiscover"
  value   = "autodiscover.outlook.com"
  type    = "CNAME"
  proxied = false
  ttl     = 300
}

resource "cloudflare_record" "selector1" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "selector1._domainkey"
  value   = "selector1-${var.symbolic_name}._domainkey.flurydotorg.onmicrosoft.com"
  type    = "CNAME"
  proxied = false
  ttl     = 300
}

resource "cloudflare_record" "selector2" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "selector2._domainkey"
  value   = "selector2-${var.symbolic_name}._domainkey.flurydotorg.onmicrosoft.com"
  type    = "CNAME"
  proxied = false
  ttl     = 300
}

resource "cloudflare_record" "spf" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "${var.domain}."
  value   = "v=spf1 include:spf.protection.outlook.com -all"
  type    = "TXT"
  proxied = false
  ttl     = 300
}

# TODO: make configurable as either a txt or cname
resource "cloudflare_record" "dmarc" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "_dmarc"
  value   = var.dmarc_cname
  type    = "CNAME"
  proxied = false
  ttl     = 300
}

resource "cloudflare_record" "validate_tls" {
  for_each = {
    for dvo in aws_acm_certificate.flurydotorg.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id         = cloudflare_zone.flurydotorg.id
  allow_overwrite = true
  name            = each.value.name
  value           = trim(each.value.record, ".")
  ttl             = 60
  type            = each.value.type
}
