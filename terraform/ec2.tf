resource "aws_security_group" "flurydotorg" {
  name = "flurydotorg"
  vpc_id = var.flurydotorg_vpc
}

resource "aws_security_group_rule" "allow_inbound_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.flurydotorg.id
}

resource "aws_security_group_rule" "allow_inbound_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.flurydotorg.id
  source_security_group_id = aws_security_group.flurydotorg_lb.id
}

resource "aws_security_group_rule" "allow_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.flurydotorg.id
} 

resource "aws_security_group" "flurydotorg_lb" {
  name   = "flurydotorg-lb"
  vpc_id = var.flurydotorg_vpc
}

resource "aws_security_group_rule" "lb_allow_inbound_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
  security_group_id = aws_security_group.flurydotorg_lb.id
}

resource "aws_security_group_rule" "lb_allow_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.flurydotorg_lb.id
}

resource "aws_instance" "flurydotorg" {
  ami                    = "ami-09d9c897fc36713bf"
  instance_type          = "t4g.nano"
  subnet_id              = var.flurydotorg_subnet_1
  key_name               = "flurydotorg-ssh"
  vpc_security_group_ids = [aws_security_group.flurydotorg.id]
  hibernation            = false
}

resource "aws_lb" "flurydotorg" {
  name               = "flurydotorg-lb"
  subnets            = [var.flurydotorg_subnet_1, var.flurydotorg_subnet_2]
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.flurydotorg_lb.id]
  access_logs {
    bucket  = aws_s3_bucket.flurydotorg_logs.bucket
    prefix  = "flurydotorg-lb"
    enabled = true
  }
}

resource "aws_lb_target_group" "flurydotorg" {
  name = "flurydotorg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.flurydotorg_vpc
}

resource "aws_lb_listener" "flurydotorg_https" {
  load_balancer_arn = aws_lb.flurydotorg.arn
  port              = 443
  protocol          = "HTTPS"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.flurydotorg.arn
  }
  certificate_arn = aws_acm_certificate_validation.flurydotorg.certificate_arn
}

resource "aws_lb_target_group_attachment" "flurydotorg" {
  target_group_arn = aws_lb_target_group.flurydotorg.arn
  target_id        = aws_instance.flurydotorg.id
}
