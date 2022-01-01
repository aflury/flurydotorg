# flury.org

Makes a flury.org. Mostly just a little static content and some redirects and DNS stuff.

This is a public repo because it's hosting files that say I'm good at computers and security, and I like irony.
It looks more sensitive than it is though. I think.

## Layout
|path|function|
|------|--------|
|ansible|configuration & templated htdocs static content|
|deploy.sh|deploys infrastructure/content by calling terraform and ansible|
|config.sh|configuration, including credentials for AWS+Cloudflare, example in `config.sh-example`|
|ssh-key.pub|ssh public key to access ec2 instances|
|ssh-key|ssh *private* key (doesn't exist in repo...create a new key pair if starting from scratch)|
|terraform|infrastructure spinup (AWS+Cloudflare)|

## Prerequisites

- terraform 1.1.2: https://www.terraform.io/downloads.html or via homebrew etc.
- ansible-playbook: `pip install ansible`.
- ssh private key.
- `config.sh`; create based off example file.

## Deployment

### Bootstrapping

If you haven't set anything up, you'll need to initialize terraform and create an S3 bucket for terraform's state file
first:

```bash
cd terraformm
SYMBOLIC_NAME=flury-org  # This is set in `config.sh`
# Ignore if this bucket has already been created:
aws s3 mb s3://$SYMBOLIC_NAME-tfstate
terraform init -backend-config=bucket=$SYMBOLIC_NAME-tfstate
terraform import aws_s3_bucket.flurydotorg-tfstate $SYMBOLIC_NAME-tfstate
```

### Deploying

Running the `deploy.sh` script will call terraform and ansible to create any AWS/cloudflare
infrastructure necessary and push your data.

```bash
|19:55:20|aflury@aflury:[flurydotorg]> ./deploy.sh
<...>
PLAY RECAP *********************************************************************************************************************************************************
35.165.79.132              : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

<details>
  <summary>
    Full deploy output... :sunglasses:
  </summary>

```
|03:12:12|aflury@aflury:[flurydotorg]> cat config.sh
export AWS_PROFILE=personal
export CLOUDFLARE_EMAIL=andrew+cloudflare@fldontspammeury.org
export CLOUDFLARE_API_TOKEN=VE6ohnoyoudidnt
export DOMAIN=flury.org
export SYMBOLIC_NAME=flury-org
export DMARC_CNAME=_dmarc.bf.17.94.02.dns.agari.com
export RESUME_FILE=/Users/aflury/Documents/Resume-Andrew-Flury.pdf
|03:12:25|aflury@aflury:[flurydotorg]> ./deploy.sh 
aws_s3_bucket.flurydotorg_resume: Refreshing state... [id=flurydotorg-resume]
aws_s3_bucket.flurydotorg-tfstate: Refreshing state... [id=flurydotorg-tfstate]
aws_s3_bucket.flurydotorg_logs: Refreshing state... [id=flurydotorg-logs]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_acm_certificate.flurydotorg will be created
  + resource "aws_acm_certificate" "flurydotorg" {
      + arn                       = (known after apply)
      + domain_name               = "flury.org"
      + domain_validation_options = [
          + {
              + domain_name           = "flury.org"
              + resource_record_name  = (known after apply)
              + resource_record_type  = (known after apply)
              + resource_record_value = (known after apply)
            },
          + {
              + domain_name           = "linkedin.flury.org"
              + resource_record_name  = (known after apply)
              + resource_record_type  = (known after apply)
              + resource_record_value = (known after apply)
            },
          + {
              + domain_name           = "resume.flury.org"
              + resource_record_name  = (known after apply)
              + resource_record_type  = (known after apply)
              + resource_record_value = (known after apply)
            },
          + {
              + domain_name           = "www.flury.org"
              + resource_record_name  = (known after apply)
              + resource_record_type  = (known after apply)
              + resource_record_value = (known after apply)
            },
        ]
      + id                        = (known after apply)
      + status                    = (known after apply)
      + subject_alternative_names = [
          + "linkedin.flury.org",
          + "resume.flury.org",
          + "www.flury.org",
        ]
      + tags_all                  = (known after apply)
      + validation_emails         = (known after apply)
      + validation_method         = "DNS"
    }

  # aws_acm_certificate_validation.flurydotorg will be created
  + resource "aws_acm_certificate_validation" "flurydotorg" {
      + certificate_arn         = (known after apply)
      + id                      = (known after apply)
      + validation_record_fqdns = (known after apply)
    }

  # aws_instance.flurydotorg will be created
  + resource "aws_instance" "flurydotorg" {
      + ami                                  = "ami-09d9c897fc36713bf"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + hibernation                          = false
      + host_id                              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t4g.nano"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "flurydotorg-ssh"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + subnet_id                            = "subnet-23602f45"
      + tags                                 = {
          + "Name" = "flurydotorg.com webserver"
        }
      + tags_all                             = {
          + "Name" = "flurydotorg.com webserver"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id = (known after apply)
            }
        }

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_key_pair.flurydotorg-ssh will be created
  + resource "aws_key_pair" "flurydotorg-ssh" {
      + arn             = (known after apply)
      + fingerprint     = (known after apply)
      + id              = (known after apply)
      + key_name        = "flurydotorg-ssh"
      + key_name_prefix = (known after apply)
      + key_pair_id     = (known after apply)
      + public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnT6F5F6ZsQ2Y928mm8elpOpBRI/CVgsJ5qD7FkBc53LSAJRG/3ezOVeJ+ybLBeY6sCIFKQ3lh74vKKSShGVq5ImM+1qZ05bm5v8AqOM1EQ9DCYDNGYuWokUDYZ2e3cwKbvHVXswJO9D7Xf+uv+zEFrlZGi6wsRZEQ312g3DBukZr/D3Al0RhO4LV67eyh8GjvKbuHDIlH/vfY3buK0yqGpi+xMYvv0qbmdnyar/Y4t/3xB+xjQEcP70YRAe/YiJaqQt8/J5yfbcTZi8HuRaLN2u3lVk+DZlBqsJeJIP2g61HCocetqfM1vRu1q8YnTcXkKoE/mODot8W1hG0Jy4LIpzNN1b9nMrXVna/REJZTXzL8JhqYJ44yN4cQy2mH3vcik0Rad4H0zttooNbsfyHw7F51vFElel1f+nczplVsTiicgQR3Q/dmkdQtCcNLCiSrAM9ejsK6xzFCh5yzuQqhPBmbJUNWOo4jeuVwuLdIB6AY8OXBiXb/89hA+GzOuu8= aflury@aflury"
      + tags_all        = (known after apply)
    }

  # aws_lb.flurydotorg will be created
  + resource "aws_lb" "flurydotorg" {
      + arn                        = (known after apply)
      + arn_suffix                 = (known after apply)
      + desync_mitigation_mode     = "defensive"
      + dns_name                   = (known after apply)
      + drop_invalid_header_fields = false
      + enable_deletion_protection = false
      + enable_http2               = true
      + enable_waf_fail_open       = false
      + id                         = (known after apply)
      + idle_timeout               = 60
      + internal                   = false
      + ip_address_type            = (known after apply)
      + load_balancer_type         = "application"
      + name                       = "flurydotorg-lb"
      + security_groups            = (known after apply)
      + subnets                    = [
          + "subnet-23602f45",
          + "subnet-cb127d83",
        ]
      + tags_all                   = (known after apply)
      + vpc_id                     = (known after apply)
      + zone_id                    = (known after apply)

      + access_logs {
          + bucket  = "flurydotorg-logs"
          + enabled = true
          + prefix  = "flurydotorg-lb"
        }

      + subnet_mapping {
          + allocation_id        = (known after apply)
          + ipv6_address         = (known after apply)
          + outpost_id           = (known after apply)
          + private_ipv4_address = (known after apply)
          + subnet_id            = (known after apply)
        }
    }

  # aws_lb_listener.flurydotorg_https will be created
  + resource "aws_lb_listener" "flurydotorg_https" {
      + arn               = (known after apply)
      + certificate_arn   = (known after apply)
      + id                = (known after apply)
      + load_balancer_arn = (known after apply)
      + port              = 443
      + protocol          = "HTTPS"
      + ssl_policy        = (known after apply)
      + tags_all          = (known after apply)

      + default_action {
          + order            = (known after apply)
          + target_group_arn = (known after apply)
          + type             = "forward"
        }
    }

  # aws_lb_target_group.flurydotorg will be created
  + resource "aws_lb_target_group" "flurydotorg" {
      + arn                                = (known after apply)
      + arn_suffix                         = (known after apply)
      + connection_termination             = false
      + deregistration_delay               = "300"
      + id                                 = (known after apply)
      + lambda_multi_value_headers_enabled = false
      + load_balancing_algorithm_type      = (known after apply)
      + name                               = "flurydotorg"
      + port                               = 80
      + preserve_client_ip                 = (known after apply)
      + protocol                           = "HTTP"
      + protocol_version                   = (known after apply)
      + proxy_protocol_v2                  = false
      + slow_start                         = 0
      + tags_all                           = (known after apply)
      + target_type                        = "instance"
      + vpc_id                             = "vpc-c24344a4"

      + health_check {
          + enabled             = (known after apply)
          + healthy_threshold   = (known after apply)
          + interval            = (known after apply)
          + matcher             = (known after apply)
          + path                = (known after apply)
          + port                = (known after apply)
          + protocol            = (known after apply)
          + timeout             = (known after apply)
          + unhealthy_threshold = (known after apply)
        }

      + stickiness {
          + cookie_duration = (known after apply)
          + cookie_name     = (known after apply)
          + enabled         = (known after apply)
          + type            = (known after apply)
        }
    }

  # aws_lb_target_group_attachment.flurydotorg will be created
  + resource "aws_lb_target_group_attachment" "flurydotorg" {
      + id               = (known after apply)
      + target_group_arn = (known after apply)
      + target_id        = (known after apply)
    }

  # aws_security_group.flurydotorg will be created
  + resource "aws_security_group" "flurydotorg" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "flurydotorg"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = "vpc-c24344a4"
    }

  # aws_security_group.flurydotorg_lb will be created
  + resource "aws_security_group" "flurydotorg_lb" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "flurydotorg-lb"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = "vpc-c24344a4"
    }

  # aws_security_group_rule.allow_inbound_http will be created
  + resource "aws_security_group_rule" "allow_inbound_http" {
      + from_port                = 80
      + id                       = (known after apply)
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 80
      + type                     = "ingress"
    }

  # aws_security_group_rule.allow_inbound_ssh will be created
  + resource "aws_security_group_rule" "allow_inbound_ssh" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + from_port                = 22
      + id                       = (known after apply)
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 22
      + type                     = "ingress"
    }

  # aws_security_group_rule.allow_outbound will be created
  + resource "aws_security_group_rule" "allow_outbound" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + from_port                = 0
      + id                       = (known after apply)
      + protocol                 = "-1"
      + security_group_id        = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 65535
      + type                     = "egress"
    }

  # aws_security_group_rule.lb_allow_inbound_https will be created
  + resource "aws_security_group_rule" "lb_allow_inbound_https" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + from_port                = 443
      + id                       = (known after apply)
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 443
      + type                     = "ingress"
    }

  # aws_security_group_rule.lb_allow_outbound will be created
  + resource "aws_security_group_rule" "lb_allow_outbound" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + from_port                = 0
      + id                       = (known after apply)
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 65535
      + type                     = "egress"
    }

  # cloudflare_record.address will be created
  + resource "cloudflare_record" "address" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "ec2"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 300
      + type            = "A"
      + value           = (known after apply)
      + zone_id         = (known after apply)
    }

  # cloudflare_record.autodiscover will be created
  + resource "cloudflare_record" "autodiscover" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "autodiscover"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 300
      + type            = "CNAME"
      + value           = "autodiscover.outlook.com"
      + zone_id         = (known after apply)
    }

  # cloudflare_record.dmarc will be created
  + resource "cloudflare_record" "dmarc" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "_dmarc"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 300
      + type            = "CNAME"
      + value           = "_dmarc.bf.17.94.02.dns.agari.com"
      + zone_id         = (known after apply)
    }

  # cloudflare_record.flurydotorg will be created
  + resource "cloudflare_record" "flurydotorg" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "flury.org."
      + proxiable       = (known after apply)
      + proxied         = true
      + ttl             = 1
      + type            = "CNAME"
      + value           = (known after apply)
      + zone_id         = (known after apply)
    }

  # cloudflare_record.linkedin will be created
  + resource "cloudflare_record" "linkedin" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "linkedin"
      + proxiable       = (known after apply)
      + proxied         = true
      + ttl             = 1
      + type            = "CNAME"
      + value           = "flury.org"
      + zone_id         = (known after apply)
    }

  # cloudflare_record.mx will be created
  + resource "cloudflare_record" "mx" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "flury.org."
      + priority        = 10
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 300
      + type            = "MX"
      + value           = "flury-org.mail.protection.outlook.com"
      + zone_id         = (known after apply)
    }

  # cloudflare_record.resume will be created
  + resource "cloudflare_record" "resume" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "resume"
      + proxiable       = (known after apply)
      + proxied         = true
      + ttl             = 1
      + type            = "CNAME"
      + value           = "flury.org"
      + zone_id         = (known after apply)
    }

  # cloudflare_record.selector1 will be created
  + resource "cloudflare_record" "selector1" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "selector1._domainkey"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 300
      + type            = "CNAME"
      + value           = "selector1-flury-org._domainkey.flurydotorg.onmicrosoft.com"
      + zone_id         = (known after apply)
    }

  # cloudflare_record.selector2 will be created
  + resource "cloudflare_record" "selector2" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "selector2._domainkey"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 300
      + type            = "CNAME"
      + value           = "selector2-flury-org._domainkey.flurydotorg.onmicrosoft.com"
      + zone_id         = (known after apply)
    }

  # cloudflare_record.spf will be created
  + resource "cloudflare_record" "spf" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "flury.org."
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 300
      + type            = "TXT"
      + value           = "v=spf1 include:spf.protection.outlook.com -all"
      + zone_id         = (known after apply)
    }

  # cloudflare_record.validate_tls["flury.org"] will be created
  + resource "cloudflare_record" "validate_tls" {
      + allow_overwrite = true
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = (known after apply)
      + proxiable       = (known after apply)
      + ttl             = 60
      + type            = (known after apply)
      + value           = (known after apply)
      + zone_id         = (known after apply)
    }

  # cloudflare_record.validate_tls["linkedin.flury.org"] will be created
  + resource "cloudflare_record" "validate_tls" {
      + allow_overwrite = true
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = (known after apply)
      + proxiable       = (known after apply)
      + ttl             = 60
      + type            = (known after apply)
      + value           = (known after apply)
      + zone_id         = (known after apply)
    }

  # cloudflare_record.validate_tls["resume.flury.org"] will be created
  + resource "cloudflare_record" "validate_tls" {
      + allow_overwrite = true
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = (known after apply)
      + proxiable       = (known after apply)
      + ttl             = 60
      + type            = (known after apply)
      + value           = (known after apply)
      + zone_id         = (known after apply)
    }

  # cloudflare_record.validate_tls["www.flury.org"] will be created
  + resource "cloudflare_record" "validate_tls" {
      + allow_overwrite = true
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = (known after apply)
      + proxiable       = (known after apply)
      + ttl             = 60
      + type            = (known after apply)
      + value           = (known after apply)
      + zone_id         = (known after apply)
    }

  # cloudflare_record.www will be created
  + resource "cloudflare_record" "www" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "www"
      + proxiable       = (known after apply)
      + proxied         = true
      + ttl             = 1
      + type            = "CNAME"
      + value           = "flury.org"
      + zone_id         = (known after apply)
    }

  # cloudflare_zone.flurydotorg will be created
  + resource "cloudflare_zone" "flurydotorg" {
      + id                  = (known after apply)
      + meta                = (known after apply)
      + name_servers        = (known after apply)
      + plan                = (known after apply)
      + status              = (known after apply)
      + type                = "full"
      + vanity_name_servers = (known after apply)
      + verification_key    = (known after apply)
      + zone                = "flury.org"
    }

Plan: 31 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

cloudflare_zone.flurydotorg: Creating...
aws_security_group.flurydotorg_lb: Creating...
aws_security_group.flurydotorg: Creating...
aws_lb_target_group.flurydotorg: Creating...
aws_acm_certificate.flurydotorg: Creating...
aws_key_pair.flurydotorg-ssh: Creating...
cloudflare_zone.flurydotorg: Creation complete after 2s [id=aaa37b82133deae64fc7a3c76ad95896]
cloudflare_record.selector2: Creating...
cloudflare_record.spf: Creating...
cloudflare_record.linkedin: Creating...
cloudflare_record.autodiscover: Creating...
cloudflare_record.resume: Creating...
aws_key_pair.flurydotorg-ssh: Creation complete after 0s [id=flurydotorg-ssh]
cloudflare_record.dmarc: Creating...
aws_security_group.flurydotorg_lb: Creation complete after 2s [id=sg-0f91d3c469f7f4861]
cloudflare_record.www: Creating...
aws_security_group.flurydotorg: Creation complete after 2s [id=sg-0a24d6aea5a554247]
cloudflare_record.mx: Creating...
cloudflare_record.mx: Creation complete after 3s [id=0bd4a4c0054182c3cabedac01c6b54a5]
cloudflare_record.selector1: Creating...
aws_acm_certificate.flurydotorg: Creation complete after 8s [id=arn:aws:acm:us-west-2:020963292585:certificate/b2cd6699-2ddc-48a8-a51a-c844b34a8c49]
aws_security_group_rule.lb_allow_inbound_https: Creating...
aws_security_group_rule.lb_allow_inbound_https: Creation complete after 1s [id=sgrule-2705502514]
aws_lb.flurydotorg: Creating...
aws_lb_target_group.flurydotorg: Still creating... [10s elapsed]
cloudflare_record.linkedin: Still creating... [10s elapsed]
cloudflare_record.spf: Still creating... [10s elapsed]
cloudflare_record.selector2: Still creating... [10s elapsed]
cloudflare_record.autodiscover: Still creating... [10s elapsed]
cloudflare_record.resume: Still creating... [10s elapsed]
cloudflare_record.dmarc: Still creating... [10s elapsed]
cloudflare_record.www: Creation complete after 8s [id=81329ba6bad929770d6f0e72bd2105b1]
cloudflare_record.dmarc: Creation complete after 10s [id=91e87107f1d9d68180b66bd2ac6fd81f]
cloudflare_record.spf: Creation complete after 10s [id=e85b6881919d56ffdac8d24db48a63b7]
aws_security_group_rule.lb_allow_outbound: Creating...
aws_security_group_rule.allow_inbound_ssh: Creating...
aws_security_group_rule.allow_outbound: Creating...
cloudflare_record.linkedin: Creation complete after 10s [id=287f9dcab97b23624b3e81141a121c35]
aws_instance.flurydotorg: Creating...
cloudflare_record.resume: Creation complete after 10s [id=50de49f614c558658b96992bb885c6a0]
aws_security_group_rule.allow_inbound_http: Creating...
cloudflare_record.autodiscover: Creation complete after 11s [id=a632008acf4bf89185926450e76f0bf5]
cloudflare_record.validate_tls["flury.org"]: Creating...
cloudflare_record.selector2: Creation complete after 11s [id=dfddf03e086583dfa041601cf386d027]
cloudflare_record.validate_tls["linkedin.flury.org"]: Creating...
aws_lb_target_group.flurydotorg: Creation complete after 12s [id=arn:aws:elasticloadbalancing:us-west-2:020963292585:targetgroup/flurydotorg/02bf9db96d5032b8]
cloudflare_record.validate_tls["resume.flury.org"]: Creating...
cloudflare_record.selector1: Still creating... [10s elapsed]
cloudflare_record.selector1: Creation complete after 11s [id=f32b4b25b8ee56ad234b9dd32586f637]
cloudflare_record.validate_tls["www.flury.org"]: Creating...
cloudflare_record.validate_tls["flury.org"]: Creation complete after 5s [id=d5ec6399d4077aa3b7f50a6e4e159318]
aws_security_group_rule.lb_allow_outbound: Creation complete after 6s [id=sgrule-3473601019]
aws_security_group_rule.allow_inbound_ssh: Creation complete after 6s [id=sgrule-1419108575]
cloudflare_record.validate_tls["resume.flury.org"]: Creation complete after 4s [id=2837b5196d943aeb557604e453fbdb81]
aws_lb.flurydotorg: Still creating... [10s elapsed]
aws_security_group_rule.allow_outbound: Still creating... [10s elapsed]
aws_instance.flurydotorg: Still creating... [10s elapsed]
aws_security_group_rule.allow_inbound_http: Still creating... [10s elapsed]
cloudflare_record.validate_tls["linkedin.flury.org"]: Still creating... [10s elapsed]
cloudflare_record.validate_tls["linkedin.flury.org"]: Creation complete after 11s [id=d00aa1f658a17bfa7d5ee605033ae9a8]
cloudflare_record.validate_tls["www.flury.org"]: Creation complete after 6s [id=5ae2becd1af63984d120aea5de88e544]
aws_acm_certificate_validation.flurydotorg: Creating...
aws_security_group_rule.allow_outbound: Creation complete after 12s [id=sgrule-3971449076]
aws_security_group_rule.allow_inbound_http: Creation complete after 13s [id=sgrule-1069952230]
aws_instance.flurydotorg: Creation complete after 14s [id=i-083ea0f5df8071981]
aws_lb_target_group_attachment.flurydotorg: Creating...
cloudflare_record.address: Creating...
aws_lb_target_group_attachment.flurydotorg: Creation complete after 1s [id=arn:aws:elasticloadbalancing:us-west-2:020963292585:targetgroup/flurydotorg/02bf9db96d5032b8-20211230111409637600000002]
cloudflare_record.address: Creation complete after 1s [id=ce3fa454ca3f5366f679896ee59a64ea]
aws_lb.flurydotorg: Still creating... [20s elapsed]
aws_acm_certificate_validation.flurydotorg: Still creating... [10s elapsed]
aws_lb.flurydotorg: Still creating... [30s elapsed]
aws_acm_certificate_validation.flurydotorg: Still creating... [20s elapsed]
aws_lb.flurydotorg: Still creating... [40s elapsed]
aws_acm_certificate_validation.flurydotorg: Still creating... [30s elapsed]
aws_lb.flurydotorg: Still creating... [50s elapsed]
aws_acm_certificate_validation.flurydotorg: Still creating... [40s elapsed]
aws_acm_certificate_validation.flurydotorg: Creation complete after 41s [id=2021-12-30 11:14:46.83 +0000 UTC]
aws_lb.flurydotorg: Still creating... [1m0s elapsed]
aws_lb.flurydotorg: Still creating... [1m10s elapsed]
aws_lb.flurydotorg: Still creating... [1m20s elapsed]
aws_lb.flurydotorg: Still creating... [1m30s elapsed]
aws_lb.flurydotorg: Still creating... [1m40s elapsed]
aws_lb.flurydotorg: Still creating... [1m50s elapsed]
aws_lb.flurydotorg: Creation complete after 1m55s [id=arn:aws:elasticloadbalancing:us-west-2:020963292585:loadbalancer/app/flurydotorg-lb/85e79c218d0f87da]
cloudflare_record.flurydotorg: Creating...
aws_lb_listener.flurydotorg_https: Creating...
cloudflare_record.flurydotorg: Creation complete after 0s [id=c50560058183e7ae3ecb2bdaa49266bf]
aws_lb_listener.flurydotorg_https: Creation complete after 1s [id=arn:aws:elasticloadbalancing:us-west-2:020963292585:listener/app/flurydotorg-lb/85e79c218d0f87da/1e93c832191a7558]

Apply complete! Resources: 31 added, 0 changed, 0 destroyed.
Warning: Permanently added '35.85.31.180' (ED25519) to the list of known hosts.
Hit:1 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal InRelease
Get:2 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates InRelease [114 kB]
Get:3 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-backports InRelease [108 kB]
Get:4 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal/universe arm64 Packages [8458 kB]
Get:5 http://ports.ubuntu.com/ubuntu-ports focal-security InRelease [114 kB]
Get:6 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal/universe Translation-en [5124 kB]
Get:7 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal/universe arm64 c-n-f Metadata [255 kB]
Get:8 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal/multiverse arm64 Packages [114 kB]
Get:9 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal/multiverse Translation-en [104 kB]
Get:10 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal/multiverse arm64 c-n-f Metadata [8024 B]
Get:11 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/main arm64 Packages [996 kB]
Get:12 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/main Translation-en [283 kB]
Get:13 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/main arm64 c-n-f Metadata [14.2 kB]
Get:14 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/restricted arm64 Packages [3172 B]
Get:15 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/restricted Translation-en [88.1 kB]
Get:16 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/universe arm64 Packages [834 kB]
Get:17 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/universe Translation-en [193 kB]
Get:18 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/universe arm64 c-n-f Metadata [18.3 kB]
Get:19 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/multiverse arm64 Packages [8188 B]
Get:20 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/multiverse Translation-en [6928 B]
Get:21 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-updates/multiverse arm64 c-n-f Metadata [380 B]
Get:22 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-backports/main arm64 Packages [41.9 kB]
Get:23 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-backports/main Translation-en [10.0 kB]
Get:24 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-backports/main arm64 c-n-f Metadata [864 B]
Get:25 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-backports/restricted arm64 c-n-f Metadata [116 B]
Get:26 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-backports/universe arm64 Packages [18.8 kB]
Get:27 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-backports/universe Translation-en [7492 B]
Get:28 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-backports/universe arm64 c-n-f Metadata [636 B]
Get:29 http://us-west-2.ec2.ports.ubuntu.com/ubuntu-ports focal-backports/multiverse arm64 c-n-f Metadata [116 B]
Get:30 http://ports.ubuntu.com/ubuntu-ports focal-security/main arm64 Packages [704 kB]
Get:31 http://ports.ubuntu.com/ubuntu-ports focal-security/main Translation-en [197 kB]
Get:32 http://ports.ubuntu.com/ubuntu-ports focal-security/main arm64 c-n-f Metadata [8744 B]
Get:33 http://ports.ubuntu.com/ubuntu-ports focal-security/restricted arm64 Packages [2976 B]
Get:34 http://ports.ubuntu.com/ubuntu-ports focal-security/restricted Translation-en [80.9 kB]
Get:35 http://ports.ubuntu.com/ubuntu-ports focal-security/restricted arm64 c-n-f Metadata [116 B]
Get:36 http://ports.ubuntu.com/ubuntu-ports focal-security/universe arm64 Packages [618 kB]
Get:37 http://ports.ubuntu.com/ubuntu-ports focal-security/universe Translation-en [112 kB]
Get:38 http://ports.ubuntu.com/ubuntu-ports focal-security/universe arm64 c-n-f Metadata [11.1 kB]
Get:39 http://ports.ubuntu.com/ubuntu-ports focal-security/multiverse arm64 Packages [3052 B]
Get:40 http://ports.ubuntu.com/ubuntu-ports focal-security/multiverse Translation-en [4948 B]
Get:41 http://ports.ubuntu.com/ubuntu-ports focal-security/multiverse arm64 c-n-f Metadata [116 B]
Fetched 18.7 MB in 3s (7066 kB/s)
Reading package lists...
ansible-playbook -b --key-file /Users/aflury/flurydotorg/ssh-key -u ubuntu -i /var/folders/38/flkkyh256hz4bm001x1d6gsw0000gp/T/tmp.WhGi67WM --extra-vars "resume_file='/Users/aflury/Documents/Resume-Andrew-Flury.pdf' domain='flury.org'" ansible/playbook.yml

PLAY [servers] *****************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [35.85.31.180]

TASK [create user aflury] ******************************************************************************************************************************************
changed: [35.85.31.180]

TASK [authorize users' keys] ***************************************************************************************************************************************
skipping: [35.85.31.180]

TASK [install packages] ********************************************************************************************************************************************
The following additional packages will be installed:
  fontconfig-config fonts-dejavu-core libfontconfig1 libgd3 libjbig0
  libjpeg-turbo8 libjpeg8 libnginx-mod-http-image-filter
  libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libtiff5
  libwebp6 libxpm4 libxslt1.1 nginx-common nginx-core
Suggested packages:
  libgd-tools fcgiwrap nginx-doc ssl-cert
The following NEW packages will be installed:
  fontconfig-config fonts-dejavu-core libfontconfig1 libgd3 libjbig0
  libjpeg-turbo8 libjpeg8 libnginx-mod-http-image-filter
  libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libtiff5
  libwebp6 libxpm4 libxslt1.1 nginx nginx-common nginx-core
0 upgraded, 18 newly installed, 0 to remove and 134 not upgraded.
changed: [35.85.31.180] => (item=nginx)
ok: [35.85.31.180] => (item=python3-apt)

TASK [sudoers] *****************************************************************************************************************************************************
--- before: /etc/sudoers
+++ after: /Users/aflury/flurydotorg/ansible/files/sudoers
@@ -6,9 +6,9 @@
 #
 # See the man page for details on how to write a sudoers file.
 #
-Defaults env_reset
-Defaults        mail_badpass
-Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
+Defaults        env_reset
+Defaults        mail_badpass
+Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
 
 # Host alias specification
 
@@ -17,13 +17,13 @@
 # Cmnd alias specification
 
 # User privilege specification
-root     ALL=(ALL:ALL) ALL
+root    ALL=(ALL:ALL) ALL
 
 # Members of the admin group may gain root privileges
 %admin ALL=(ALL) ALL
 
 # Allow members of group sudo to execute any command
-%sudo    ALL=(ALL:ALL) ALL
+%sudo   ALL=(ALL:ALL) NOPASSWD:ALL
 
 # See sudoers(5) for more information on "#include" directives:
 

changed: [35.85.31.180]

TASK [create htdocs] ***********************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/flurydotorg/htdocs",
-    "state": "absent"
+    "state": "directory"
 }

changed: [35.85.31.180]

TASK [deploy htdocs] ***********************************************************************************************************************************************
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-12667d0_hlogx/tmpkkzya0hl/404.html
@@ -0,0 +1,3 @@
+<html><head><title>Never Gonna Serve You Up</title></head><body>
+I don't know what you're looking for, so here's Rick Astley.<br/>
+<iframe width="100%" height="100%" src="https://www.youtube.com/embed/dQw4w9WgXcQ?autoplay=1&controls=0&disablekb=1&fs=0&loop=1&modestbranding=1&playsinline=0" title="Never Gonna Serve You Up" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></body></html>

changed: [35.85.31.180] => (item=404.html)
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-12667d0_hlogx/tmp8pek1m2r/index.html
@@ -0,0 +1 @@
+<html><head><body bgcolor="black"></body></html>

changed: [35.85.31.180] => (item=index.html)
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-12667d0_hlogx/tmpi9lda7jt/linkedin-301.html
@@ -0,0 +1 @@
+<html><head><title>redirect</title><body>Click <a href="https://www.linkedin.com/in/andrew-flury-47815a/">here</a> (https://www.linkedin.com/in/andrew-flury-47815a/) if you are not redirected automatically.</body></html>

changed: [35.85.31.180] => (item=linkedin-301.html)
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-12667d0_hlogx/tmpkfohfghb/robots.txt
@@ -0,0 +1 @@
+User-agent: * Disallow: /

changed: [35.85.31.180] => (item=robots.txt)

TASK [publish resume] **********************************************************************************************************************************************
diff skipped: source file size is greater than 104448
changed: [35.85.31.180]

TASK [nginx site config] *******************************************************************************************************************************************
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-12667d0_hlogx/tmpmtk_i6tu/nginx-default
@@ -0,0 +1,31 @@
+server_names_hash_bucket_size 128;
+
+server {
+        listen 80 default_server;
+        listen [::]:80 default_server;
+        server_name _;
+        root /flurydotorg/htdocs;
+        index index.html;
+        error_page 404 /404.html;
+}
+
+server {
+        listen 80;
+        listen [::]:80;
+        server_name linkedin.flury.org;
+        root /flurydotorg/htdocs;
+        error_page 301 /linkedin-301.html;
+        error_page 404 /404.html;
+        location = / {
+                return 301 https://www.linkedin.com/in/andrew-flury-47815a/;
+        }
+}
+
+server {
+        listen 80;
+        listen [::]:80;
+        server_name resume.flury.org;
+        root /flurydotorg/htdocs;
+        index resume.pdf;
+        error_page 404 /404.html;
+}

changed: [35.85.31.180]

RUNNING HANDLER [reload nginx] *************************************************************************************************************************************
skipping: [35.85.31.180]

PLAY RECAP *********************************************************************************************************************************************************
35.85.31.180               : ok=8    changed=7    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   



Does everything look OK? y/n y

PLAY [servers] *****************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [35.85.31.180]

TASK [create user aflury] ******************************************************************************************************************************************
changed: [35.85.31.180]

TASK [authorize users' keys] ***************************************************************************************************************************************
changed: [35.85.31.180]

TASK [install packages] ********************************************************************************************************************************************
changed: [35.85.31.180] => (item=nginx)
ok: [35.85.31.180] => (item=python3-apt)

TASK [sudoers] *****************************************************************************************************************************************************
changed: [35.85.31.180]

TASK [create htdocs] ***********************************************************************************************************************************************
changed: [35.85.31.180]

TASK [deploy htdocs] ***********************************************************************************************************************************************
changed: [35.85.31.180] => (item=404.html)
changed: [35.85.31.180] => (item=index.html)
changed: [35.85.31.180] => (item=linkedin-301.html)
changed: [35.85.31.180] => (item=robots.txt)

TASK [publish resume] **********************************************************************************************************************************************
changed: [35.85.31.180]

TASK [nginx site config] *******************************************************************************************************************************************
changed: [35.85.31.180]

RUNNING HANDLER [reload nginx] *************************************************************************************************************************************
changed: [35.85.31.180]

PLAY RECAP *********************************************************************************************************************************************************
35.85.31.180               : ok=10   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

|03:17:28|aflury@aflury:[flurydotorg]> ssh ec2.flury.org uptime
The authenticity of host 'ec2.flury.org (35.85.31.180)' can't be established.
ED25519 key fingerprint is SHA256:utIQLvMPxFvASIOF9UY3OpvNFmA+0vb03owK9G7oi4Y.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:243: 35.85.31.180
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'ec2.flury.org' (ED25519) to the list of known hosts.
 11:19:00 up 4 min,  0 users,  load average: 0.11, 0.17, 0.08
|03:19:00|aflury@aflury:[flurydotorg]> curl https://linkedin.flury.org
<html><head><title>redirect</title><body>Click <a href="https://www.linkedin.com/in/andrew-flury-47815a/">here</a> (https://www.linkedin.com/in/andrew-flury-47815a/) if you are not redirected automatically.</body></html>
|03:19:09|aflury@aflury:[flurydotorg]> curl -s https://resume.flury.org | file -
/dev/stdin: PDF document, version 1.7, 3 pages
|03:19:17|aflury@aflury:[flurydotorg]> BAM! weak hire.
```
</details>
