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
|22:39:30|aflury@aflury:[flurydotorg]> cat config.sh
export AWS_PROFILE=personal
export CLOUDFLARE_EMAIL=andrew+cloudflare@flunospamry.org
export CLOUDFLARE_API_TOKEN=VEohnoyoudidnt
export DOMAIN=flury.org
export SYMBOLIC_NAME=flury-org
export DMARC_CNAME=_dmarc.bf.17.94.02.dns.agari.com
export RESUME_FILE=/Users/aflury/Documents/Resume-Andrew-Flury.pdf
export LINKEDIN_PROFILE=andrew-flury-47815a
|22:39:33|aflury@aflury:[flurydotorg]> ./deploy.sh 

**************************************************
**
**  Running terraform apply
**
**************************************************

aws_s3_bucket.flurydotorg-tfstate: Refreshing state... [id=flury-org-tfstate]
aws_s3_bucket.flurydotorg_logs: Refreshing state... [id=flury-org-logs]

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
              + domain_name           = "message.flury.org"
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
          + {
              + domain_name           = "xn--rsum-bpad.flury.org"
              + resource_record_name  = (known after apply)
              + resource_record_type  = (known after apply)
              + resource_record_value = (known after apply)
            },
        ]
      + id                        = (known after apply)
      + status                    = (known after apply)
      + subject_alternative_names = [
          + "linkedin.flury.org",
          + "message.flury.org",
          + "resume.flury.org",
          + "www.flury.org",
          + "xn--rsum-bpad.flury.org",
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
          + "Name" = "flury-org webserver"
        }
      + tags_all                             = {
          + "Name" = "flury-org webserver"
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
          + bucket  = "flury-org-logs"
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

  # cloudflare_record.message will be created
  + resource "cloudflare_record" "message" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "message"
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

  # cloudflare_record.resume_ will be created
  + resource "cloudflare_record" "resume_" {
      + allow_overwrite = false
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "xn--rsum-bpad"
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

  # cloudflare_record.validate_tls["message.flury.org"] will be created
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

  # cloudflare_record.validate_tls["xn--rsum-bpad.flury.org"] will be created
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

Plan: 35 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

cloudflare_zone.flurydotorg: Creating...
aws_key_pair.flurydotorg-ssh: Creating...
aws_security_group.flurydotorg: Creating...
aws_security_group.flurydotorg_lb: Creating...
aws_lb_target_group.flurydotorg: Creating...
aws_acm_certificate.flurydotorg: Creating...
cloudflare_zone.flurydotorg: Creation complete after 2s [id=aaa37b82133deae64fc7a3c76ad95896]
cloudflare_record.selector1: Creating...
cloudflare_record.autodiscover: Creating...
cloudflare_record.selector2: Creating...
cloudflare_record.spf: Creating...
cloudflare_record.www: Creating...
aws_key_pair.flurydotorg-ssh: Creation complete after 1s [id=flurydotorg-ssh]
cloudflare_record.linkedin: Creating...
aws_security_group.flurydotorg_lb: Creation complete after 3s [id=sg-051beca8710b89480]
cloudflare_record.mx: Creating...
aws_security_group.flurydotorg: Creation complete after 3s [id=sg-046aa7e825ecebd8c]
cloudflare_record.message: Creating...
cloudflare_record.autodiscover: Creation complete after 5s [id=9747cb4fe31e863b6f6ecf262a143767]
cloudflare_record.resume_: Creating...
cloudflare_record.selector1: Creation complete after 5s [id=66d61dabef39d370fb78695a662922ae]
cloudflare_record.dmarc: Creating...
cloudflare_record.www: Creation complete after 5s [id=2b3d56a8ddd88b0e34a27c4ea5914b1e]
cloudflare_record.resume: Creating...
aws_lb_target_group.flurydotorg: Still creating... [10s elapsed]
aws_acm_certificate.flurydotorg: Still creating... [10s elapsed]
cloudflare_record.spf: Still creating... [10s elapsed]
cloudflare_record.selector2: Still creating... [10s elapsed]
cloudflare_record.linkedin: Still creating... [10s elapsed]
cloudflare_record.mx: Creation complete after 9s [id=1e89c39e9cdf6ddbbaf816ff4bdfcca1]
aws_security_group_rule.lb_allow_inbound_https: Creating...
cloudflare_record.selector2: Creation complete after 11s [id=a0872dce64f9de268c6ffe092810106b]
aws_security_group_rule.lb_allow_outbound: Creating...
aws_lb_target_group.flurydotorg: Creation complete after 12s [id=arn:aws:elasticloadbalancing:us-west-2:020963292585:targetgroup/flurydotorg/5e91587969ade84a]
aws_lb.flurydotorg: Creating...
cloudflare_record.linkedin: Creation complete after 11s [id=e2768a484a47adfbcb313f9224ba883d]
aws_security_group_rule.allow_outbound: Creating...
cloudflare_record.dmarc: Creation complete after 6s [id=30423c4ce001808933d53fdd9db688b6]
aws_security_group_rule.allow_inbound_http: Creating...
cloudflare_record.message: Still creating... [10s elapsed]
cloudflare_record.resume_: Still creating... [10s elapsed]
cloudflare_record.resume: Still creating... [10s elapsed]
cloudflare_record.spf: Creation complete after 16s [id=08763428d9fe4a5f47881924807c261a]
aws_instance.flurydotorg: Creating...
cloudflare_record.resume_: Creation complete after 11s [id=57dd9b49e73008014c2cc2fdfd204b0c]
aws_security_group_rule.allow_inbound_ssh: Creating...
cloudflare_record.resume: Creation complete after 11s [id=cd8e7d9b8e9da9658625b0c16f170b79]
cloudflare_record.message: Creation complete after 14s [id=97dd1f67f0888d936fcf0c448481071f]
aws_security_group_rule.lb_allow_inbound_https: Creation complete after 5s [id=sgrule-2913447214]
aws_security_group_rule.allow_outbound: Creation complete after 6s [id=sgrule-4018660446]
aws_acm_certificate.flurydotorg: Still creating... [20s elapsed]
aws_security_group_rule.lb_allow_outbound: Still creating... [10s elapsed]
aws_lb.flurydotorg: Still creating... [10s elapsed]
aws_security_group_rule.allow_inbound_http: Still creating... [10s elapsed]
aws_acm_certificate.flurydotorg: Creation complete after 23s [id=arn:aws:acm:us-west-2:020963292585:certificate/6f004307-c0e8-47c0-8d18-404f917343db]
cloudflare_record.validate_tls["flury.org"]: Creating...
cloudflare_record.validate_tls["www.flury.org"]: Creating...
cloudflare_record.validate_tls["message.flury.org"]: Creating...
cloudflare_record.validate_tls["xn--rsum-bpad.flury.org"]: Creating...
cloudflare_record.validate_tls["linkedin.flury.org"]: Creating...
aws_security_group_rule.lb_allow_outbound: Creation complete after 11s [id=sgrule-1934570503]
cloudflare_record.validate_tls["resume.flury.org"]: Creating...
aws_security_group_rule.allow_inbound_http: Creation complete after 11s [id=sgrule-478459259]
cloudflare_record.validate_tls["www.flury.org"]: Creation complete after 1s [id=11723b82b46c1b80e15390f95958c57a]
cloudflare_record.validate_tls["linkedin.flury.org"]: Creation complete after 1s [id=a52bd874250b0f9d00ee6249a2fe26e3]
aws_security_group_rule.allow_inbound_ssh: Creation complete after 8s [id=sgrule-1396379152]
cloudflare_record.validate_tls["xn--rsum-bpad.flury.org"]: Creation complete after 2s [id=51aed3cc2a002a0027748b3b12953016]
cloudflare_record.validate_tls["flury.org"]: Creation complete after 2s [id=8a04366e7dfaf7ba927cac6fcbbb6515]
cloudflare_record.validate_tls["message.flury.org"]: Creation complete after 2s [id=ab604d8738c46b4c01cca219617ee3e4]
cloudflare_record.validate_tls["resume.flury.org"]: Creation complete after 3s [id=398d80484e3f25b499d5f344bc0cc210]
aws_acm_certificate_validation.flurydotorg: Creating...
aws_instance.flurydotorg: Still creating... [10s elapsed]
aws_instance.flurydotorg: Creation complete after 13s [id=i-0ae3d853daa3a411c]
aws_lb_target_group_attachment.flurydotorg: Creating...
cloudflare_record.address: Creating...
aws_lb_target_group_attachment.flurydotorg: Creation complete after 1s [id=arn:aws:elasticloadbalancing:us-west-2:020963292585:targetgroup/flurydotorg/5e91587969ade84a-20220103064024774800000002]
cloudflare_record.address: Creation complete after 1s [id=3e72c7d31b3718c85c06fa0e2ddbf379]
aws_lb.flurydotorg: Still creating... [20s elapsed]
aws_acm_certificate_validation.flurydotorg: Still creating... [10s elapsed]
aws_lb.flurydotorg: Still creating... [30s elapsed]
aws_acm_certificate_validation.flurydotorg: Still creating... [20s elapsed]
aws_lb.flurydotorg: Still creating... [40s elapsed]
aws_acm_certificate_validation.flurydotorg: Still creating... [30s elapsed]
aws_lb.flurydotorg: Still creating... [50s elapsed]
aws_acm_certificate_validation.flurydotorg: Still creating... [40s elapsed]
aws_acm_certificate_validation.flurydotorg: Creation complete after 41s [id=2022-01-03 06:40:56.443 +0000 UTC]
aws_lb.flurydotorg: Still creating... [1m0s elapsed]
aws_lb.flurydotorg: Still creating... [1m10s elapsed]
aws_lb.flurydotorg: Still creating... [1m20s elapsed]
aws_lb.flurydotorg: Still creating... [1m30s elapsed]
aws_lb.flurydotorg: Still creating... [1m40s elapsed]
aws_lb.flurydotorg: Still creating... [1m50s elapsed]
aws_lb.flurydotorg: Still creating... [2m0s elapsed]
aws_lb.flurydotorg: Still creating... [2m10s elapsed]
aws_lb.flurydotorg: Still creating... [2m20s elapsed]
aws_lb.flurydotorg: Creation complete after 2m29s [id=arn:aws:elasticloadbalancing:us-west-2:020963292585:loadbalancer/app/flurydotorg-lb/aa8a759d872a7272]
cloudflare_record.flurydotorg: Creating...
aws_lb_listener.flurydotorg_https: Creating...
cloudflare_record.flurydotorg: Creation complete after 0s [id=d0a111fc497255e6b07172dfce93fd86]
aws_lb_listener.flurydotorg_https: Creation complete after 1s [id=arn:aws:elasticloadbalancing:us-west-2:020963292585:listener/app/flurydotorg-lb/aa8a759d872a7272/ba453c2faad35236]

Apply complete! Resources: 35 added, 0 changed, 0 destroyed.
Warning: Permanently added '34.216.71.114' (ED25519) to the list of known hosts.
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
Fetched 18.7 MB in 3s (7032 kB/s)
Reading package lists...

**************************************************
**
**  Running ansible-playbook check
**
**************************************************


PLAY [servers] *************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************
ok: [34.216.71.114]

TASK [create user aflury] **************************************************************************************************************************************************
changed: [34.216.71.114]

TASK [authorize users' keys] ***********************************************************************************************************************************************
skipping: [34.216.71.114]

TASK [install packages] ****************************************************************************************************************************************************
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
changed: [34.216.71.114] => (item=nginx)
ok: [34.216.71.114] => (item=python3-apt)

TASK [sudoers] *************************************************************************************************************************************************************
--- before: /etc/sudoers
+++ after: /Users/aflury/flurydotorg/ansible/files/sudoers
@@ -6,9 +6,9 @@
 #
 # See the man page for details on how to write a sudoers file.
 #
-Defaults	env_reset
-Defaults	mail_badpass
-Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
+Defaults        env_reset
+Defaults        mail_badpass
+Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
 
 # Host alias specification
 
@@ -17,13 +17,13 @@
 # Cmnd alias specification
 
 # User privilege specification
-root	ALL=(ALL:ALL) ALL
+root    ALL=(ALL:ALL) ALL
 
 # Members of the admin group may gain root privileges
 %admin ALL=(ALL) ALL
 
 # Allow members of group sudo to execute any command
-%sudo	ALL=(ALL:ALL) ALL
+%sudo   ALL=(ALL:ALL) NOPASSWD:ALL
 
 # See sudoers(5) for more information on "#include" directives:
 

changed: [34.216.71.114]

TASK [create htdocs] *******************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/flurydotorg/htdocs",
-    "state": "absent"
+    "state": "directory"
 }

changed: [34.216.71.114]

TASK [deploy htdocs files] *************************************************************************************************************************************************
diff skipped: source file appears to be binary
changed: [34.216.71.114] => (item=favicon.ico)

TASK [deploy htdocs templates] *********************************************************************************************************************************************
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-20196_lnjmfod/tmp12rsju3a/404.html
@@ -0,0 +1,3 @@
+<html><head><title>Never Gonna Serve You Up</title></head><body>
+I don't know what you're looking for, so here's Rick Astley.<br/>
+<iframe width="100%" height="100%" src="https://www.youtube.com/embed/dQw4w9WgXcQ?autoplay=1&controls=0&disablekb=1&fs=0&loop=1&modestbranding=1&playsinline=0" title="Never Gonna Serve You Up" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></body></html>

changed: [34.216.71.114] => (item=404.html)
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-20196_lnjmfod/tmpc1jlox9h/index.html
@@ -0,0 +1 @@
+<html><head><body bgcolor="black"></body></html>

changed: [34.216.71.114] => (item=index.html)
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-20196_lnjmfod/tmpptwxvi4k/linkedin-301.html
@@ -0,0 +1 @@
+<html><head><title>redirect</title><body>Click <a href="https://www.linkedin.com/in/andrew-flury-47815a/">here</a> (https://www.linkedin.com/in/andrew-flury-47815a/) if you are not redirected automatically.</body></html>

changed: [34.216.71.114] => (item=linkedin-301.html)
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-20196_lnjmfod/tmp_o2fehe8/message-301.html
@@ -0,0 +1 @@
+<html><head><title>redirect</title><body>Click <a href="https://www.linkedin.com/messaging/thread/new?recipient=andrew-flury-47815a">here</a> (https://www.linkedin.com/messaging/thread/new?recipient=andrew-flury-47815a) if you are not redirected automatically.</body></html>

changed: [34.216.71.114] => (item=message-301.html)
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-20196_lnjmfod/tmpef7jvdey/robots.txt
@@ -0,0 +1 @@
+User-agent: * Disallow: /

changed: [34.216.71.114] => (item=robots.txt)

TASK [publish resume] ******************************************************************************************************************************************************
diff skipped: source file size is greater than 104448
changed: [34.216.71.114]

TASK [nginx site config] ***************************************************************************************************************************************************
--- before
+++ after: /Users/aflury/.ansible/tmp/ansible-local-20196_lnjmfod/tmpxyybrgez/nginx-default
@@ -0,0 +1,46 @@
+server_names_hash_bucket_size 128;
+
+server {
+	listen 80 default_server;
+	listen [::]:80 default_server;
+	server_name _;
+	root /flurydotorg/htdocs;
+	index index.html;
+	error_page 404 /404.html;
+}
+
+server {
+	listen 80;
+	listen [::]:80;
+	server_name linkedin.flury.org;
+	root /flurydotorg/htdocs;
+	error_page 301 /linkedin-301.html;
+	error_page 404 /404.html;
+	location = / {
+		return 301 "https://www.linkedin.com/in/andrew-flury-47815a/";
+	}
+}
+
+server {
+        listen 80;
+        listen [::]:80;
+        server_name message.flury.org;
+        root /flurydotorg/htdocs;
+        error_page 301 /message-301.html;
+        error_page 404 /404.html;
+        location = / {
+                return 301 "https://www.linkedin.com/messaging/thread/new?recipient=andrew-flury-47815a";
+        }
+}
+
+server {
+	listen 80;
+	listen [::]:80;
+	server_name resume.flury.org xn--rsum-bpad.flury.org;
+	root /flurydotorg/htdocs;
+	index resume.pdf;
+	error_page 404 /404.html;
+	location / {
+		add_header Content-Disposition 'filename="Resume-Andrew-Flury.pdf"';
+	}
+}

changed: [34.216.71.114]

RUNNING HANDLER [reload nginx] *********************************************************************************************************************************************
skipping: [34.216.71.114]

PLAY RECAP *****************************************************************************************************************************************************************
34.216.71.114              : ok=9    changed=8    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   



Does everything look OK? y/n y

**************************************************
**
**  Running ansible-playbook
**
**************************************************

+ ansible-playbook -b --key-file /Users/aflury/flurydotorg/ssh-key -u ubuntu -i /var/folders/38/flkkyh256hz4bm001x1d6gsw0000gp/T/tmp.OkESEhUw --extra-vars 'linkedin_profile='\''andrew-flury-47815a'\'' resume_file='\''/Users/aflury/Documents/Resume-Andrew-Flury.pdf'\'' resume_base='\''Resume-Andrew-Flury.pdf'\'' domain='\''flury.org'\''' ansible/playbook.yml

PLAY [servers] *************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************
ok: [34.216.71.114]

TASK [create user aflury] **************************************************************************************************************************************************
changed: [34.216.71.114]

TASK [authorize users' keys] ***********************************************************************************************************************************************
changed: [34.216.71.114]

TASK [install packages] ****************************************************************************************************************************************************
changed: [34.216.71.114] => (item=nginx)
ok: [34.216.71.114] => (item=python3-apt)

TASK [sudoers] *************************************************************************************************************************************************************
changed: [34.216.71.114]

TASK [create htdocs] *******************************************************************************************************************************************************
changed: [34.216.71.114]

TASK [deploy htdocs files] *************************************************************************************************************************************************
changed: [34.216.71.114] => (item=favicon.ico)

TASK [deploy htdocs templates] *********************************************************************************************************************************************
changed: [34.216.71.114] => (item=404.html)
changed: [34.216.71.114] => (item=index.html)
changed: [34.216.71.114] => (item=linkedin-301.html)
changed: [34.216.71.114] => (item=message-301.html)
changed: [34.216.71.114] => (item=robots.txt)

TASK [publish resume] ******************************************************************************************************************************************************
changed: [34.216.71.114]

TASK [nginx site config] ***************************************************************************************************************************************************
changed: [34.216.71.114]

RUNNING HANDLER [reload nginx] *********************************************************************************************************************************************
changed: [34.216.71.114]

PLAY RECAP *****************************************************************************************************************************************************************
34.216.71.114              : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

|22:45:10|aflury@aflury:[flurydotorg]> ssh ec2.flury.org uptime
The authenticity of host 'ec2.flury.org (34.216.71.114)' can't be established.
ED25519 key fingerprint is SHA256:+bD62L63LTS3dWFZJ6OqcHHQUO7lm02PeOfnGg+QewM.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:257: 34.216.71.114
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'ec2.flury.org' (ED25519) to the list of known hosts.
 06:46:43 up 6 min,  0 users,  load average: 1.01, 0.34, 0.14
|22:46:43|aflury@aflury:[flurydotorg]> curl -s https://linkedin.flury.org
<html><head><title>redirect</title><body>Click <a href="https://www.linkedin.com/in/andrew-flury-47815a/">here</a> (https://www.linkedin.com/in/andrew-flury-47815a/) if you are not redirected automatically.</body></html>
|22:46:51|aflury@aflury:[flurydotorg]> curl -s https://message.flury.org
<html><head><title>redirect</title><body>Click <a href="https://www.linkedin.com/messaging/thread/new?recipient=andrew-flury-47815a">here</a> (https://www.linkedin.com/messaging/thread/new?recipient=andrew-flury-47815a) if you are not redirected automatically.</body></html>
|22:47:04|aflury@aflury:[flurydotorg]> curl -s https://resume.flury.org | file -
/dev/stdin: PDF document, version 1.7, 3 pages
|22:47:17|aflury@aflury:[flurydotorg]> WEAK HIRE!
```
</details>
