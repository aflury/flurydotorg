resource "cloudflare_workers_kv_namespace" "flurydotorg" {
    title = "flurydotorg_namespace"
}

resource "cloudflare_worker_script" "flurydotorg" {
    name    = "flurydotorg"
    content = templatefile("templates/index.js", {
        dd_api_key         = var.dd_api_key
        dd_app_key         = var.dd_app_key
        domain             = var.domain
        linkedin_profile   = var.linkedin_profile
        profile_photo_base = var.profile_photo_base
        resume_file_base   = var.resume_file_base
    })
    kv_namespace_binding {
        name         = "flurydotorg_namespace"
        namespace_id = cloudflare_workers_kv_namespace.flurydotorg.id
    }
}

# This doesn't exist yet? Looks like the feature just went beta so
# it still needs terraform support.
# The purpose is to configure a domain that isn't proxied to an actual
# origin server other than workers (i.e. you're *only* serving via
# workers). Currently it has to be configured by hand.
# TODO: Look into adding support to the cloudflare provider?
#
# resource "cloudflare_worker_custom_domain" "flurydotorg" {
#  zone_id     = cloudflare_zone.flurydotorg.id
#  name        = var.domain
#  script_name = cloudflare_Worker_script.flurydotorg.name
# }

# INTERCEPT ALL THE REQUESTS!
resource "cloudflare_worker_route" "flurydotorg" {
    pattern     = "*${var.domain}/*"
    script_name = cloudflare_worker_script.flurydotorg.name
    zone_id     = cloudflare_zone.flurydotorg.id
}

# This maps everything under `terraform/files/*` to the equivalent workers
# KV key/value pair, where each key is the path (including `files/`) and
# each value is the base64-encoded file contents.
resource "cloudflare_workers_kv" "files" {
    namespace_id = cloudflare_workers_kv_namespace.flurydotorg.id
    for_each     = fileset(path.module, "files/**")
    key          = each.key
    value        = filebase64(each.key)
}

resource "cloudflare_workers_kv" "profile_photo" {
    namespace_id = cloudflare_workers_kv_namespace.flurydotorg.id
    key          = var.profile_photo_base
    value        = filebase64("tmp/${var.profile_photo_base}")
}

resource "cloudflare_workers_kv" "resume" {
    namespace_id = cloudflare_workers_kv_namespace.flurydotorg.id
    key          = var.resume_file_base
    value        = filebase64("tmp/${var.resume_file_base}")
}

# Same but for templating. I think this is turning into a webserver.
resource "cloudflare_workers_kv" "templates" {
    namespace_id = cloudflare_workers_kv_namespace.flurydotorg.id
    for_each     = fileset(path.module, "templates/**")
    key          = each.key
    value        = templatefile(each.key, {
        dd_api_key         = var.dd_api_key
        dd_app_key         = var.dd_app_key
        domain             = var.domain
        email              = var.email
        full_name          = var.full_name
        linkedin_profile   = var.linkedin_profile
        phone              = var.phone
        profile_photo_base = var.profile_photo_base
        resume_file_base   = var.resume_file_base
    })
}
