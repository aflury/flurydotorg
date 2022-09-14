variable "cloudflare_email" {
  description = "Cloudflare account email address"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
}

variable "domain" {
  description = "Domain name for which to publish"
}

variable "dmarc_record" {
  description = "Value of DMARC TXT DNS record"
}

variable "spf_record" {
  description = "Value of SPF TXT DNS record"
}

variable "symbolic_name" {
  description = "Symbolic name of Microsoft Office365 organization. e.g. `flury-org`"
}

variable "linkedin_profile" {
  description = "LinkedIn profile name (used to build profile URL)"
}

variable "email" {
  description = "Email address"
}

variable "phone" {
  description = "Phone#"
}

variable "profile_photo_base" {
  description = "Profile photo base filename"
}

variable "resume_file_base" {
  description = "Resume base (non-directory-part) filename"
}

variable "full_name" {
  description = "Full name"
}

variable "dd_api_key" {
  description = "Datadog API key"
}

variable "dd_app_key" {
  description = "Datadog application key"
}

variable "calendly_profile" {
  description = "Calendly profile name, to be used for https://calendly.com/<profile-name>"
}