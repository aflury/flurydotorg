terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
  required_version = "=1.1.2"

  backend "s3" {
    # bucket is set by `terraform init`.
    key    = "terraform.tfstate"
  }
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Name = var.symbolic_name
    }
  }
}
