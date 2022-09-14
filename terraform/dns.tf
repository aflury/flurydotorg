resource "cloudflare_zone" "flurydotorg" {
  zone = var.domain
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

resource "cloudflare_record" "call" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "call"
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

resource "cloudflare_record" "cv" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "cv"
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

resource "cloudflare_record" "redirect" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "redirect"
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

resource "cloudflare_record" "text" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "text"
  value   = var.domain
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "meet" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "meet"
  value   = var.domain
  type    = "CNAME"
  proxied = true
  ttl     = 1
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
  value   = var.spf_record
  type    = "TXT"
  proxied = false
  ttl     = 300
}

# TODO: make configurable as either a txt or cname
resource "cloudflare_record" "dmarc" {
  zone_id = cloudflare_zone.flurydotorg.id
  name    = "_dmarc"
  value   = var.dmarc_record
  type    = "TXT"
  proxied = false
  ttl     = 300
}