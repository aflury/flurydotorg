terraform {
  cloud {
    workspaces {
      name = "flurydotorg"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
  required_version = "~> 1.2.0"
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}

data "cloudflare_ip_ranges" "cloudflare" {}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Name = var.symbolic_name
    }
  }
}
