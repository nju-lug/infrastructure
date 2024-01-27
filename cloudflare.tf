provider "cloudflare" {
}

variable "cloudflare_account_id" {
  type = string
}

resource "cloudflare_zone" "njulug-org" {
  account_id = var.cloudflare_account_id
  zone       = "njulug.org"
}

# ttl = 1 for automatic

# njulug.org

resource "cloudflare_record" "njulug" {
  name    = "njulug.org"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "nju-lug.github.io"
  zone_id = cloudflare_zone.njulug-org.id
}

# 302 redirect njulug.org to https://github.com/nju-lug
resource "cloudflare_page_rule" "njulug_to_github" {
  priority = 1
  status   = "active"
  target   = "njulug.org/"
  zone_id  = cloudflare_zone.njulug-org.id
  actions {
    forwarding_url {
      status_code = 302
      url         = "https://github.com/nju-lug"
    }
  }
}

# blogroll

resource "cloudflare_record" "blogroll" {
  name    = "blogroll"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "blogroll.0yinfeng1686.workers.dev"
  zone_id = cloudflare_zone.njulug-org.id
}

# email routing

resource "cloudflare_email_routing_settings" "njulug" {
  zone_id = cloudflare_zone.njulug-org.id
  enabled = true
}

resource "cloudflare_email_routing_rule" "postmaster" {
  zone_id = cloudflare_zone.njulug-org.id
  name    = "postmaster"
  enabled = true
  matcher {
    type  = "literal"
    field = "to"
    value = "postmaster@njulug.org"
  }
  action {
    type  = "forward"
    value = ["lin.yinfeng@outlook.com"]
  }
}

resource "cloudflare_email_routing_rule" "admin" {
  zone_id = cloudflare_zone.njulug-org.id
  name    = "admin"
  enabled = true
  matcher {
    type  = "literal"
    field = "to"
    value = "admin@njulug.org"
  }
  action {
    type  = "forward"
    value = ["lin.yinfeng@outlook.com"]
  }
}

resource "cloudflare_email_routing_catch_all" "njulug" {
  zone_id = cloudflare_zone.njulug-org.id
  name    = "catch all"
  enabled = true
  matcher {
    type = "all"
  }
  action {
    type  = "drop"
    value = []
  }
}
