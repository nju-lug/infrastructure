provider "cloudflare" {
}

resource "cloudflare_zone" "njulug-org" {
  zone   = "njulug.org"
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
  zone_id = cloudflare_zone.njulug-org.id
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

# cloudflare email routing

resource "cloudflare_record" "mx70" {
  name     = "njulug.org"
  priority = 70
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "amir.mx.cloudflare.net"
  zone_id  = cloudflare_zone.njulug-org.id
}

resource "cloudflare_record" "mx38" {
  name     = "njulug.org"
  priority = 38
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "linda.mx.cloudflare.net"
  zone_id  = cloudflare_zone.njulug-org.id
}

resource "cloudflare_record" "mx32" {
  name     = "njulug.org"
  priority = 32
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "isaac.mx.cloudflare.net"
  zone_id  = cloudflare_zone.njulug-org.id
}

resource "cloudflare_record" "spf" {
  name    = "njulug.org"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=spf1 include:_spf.mx.cloudflare.net ~all"
  zone_id = cloudflare_zone.njulug-org.id
}