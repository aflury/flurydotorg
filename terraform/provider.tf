terraform {
  cloud {
    workspaces {
      name = "flurydotorg"
    }
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "= 3.17.0"
    }
  }
  required_version = "~> 1.2.0"
}

provider "cloudflare" {
  email      = var.cloudflare_email
  api_token  = var.cloudflare_api_token
  account_id = var.cloudflare_account_id
}

data "cloudflare_ip_ranges" "cloudflare" {}
