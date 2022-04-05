variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "aws_account_id" {
  description = "AWS account ID"
}

variable "flurydotorg_vpc" {
  description = "VPC we want to run in"
  default     = "vpc-c24344a4"
}

variable "flurydotorg_subnet_1" {
  description = "first (primary) subnet"
  default     = "subnet-23602f45"
}

# This subnet only exists because the ALB wants two endpoints.
# We don't care about redundancy right now so it's only actually running on the primary.
variable "flurydotorg_subnet_2" {
  description = "second (down) subnet"
  default     = "subnet-cb127d83"
}

variable "cloudflare_email" {
  description = "Cloudflare account email address"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
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
