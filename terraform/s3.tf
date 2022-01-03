resource "aws_s3_bucket" "flurydotorg-tfstate" {
  bucket = "${var.symbolic_name}-tfstate"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "flurydotorg_logs" {
  bucket = "${var.symbolic_name}-logs"
  policy = data.aws_iam_policy_document.flurydotorg_logs.json
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule {
    enabled = true
    expiration {
      days = "30"
    }
  }
}

data "aws_iam_policy_document" "flurydotorg_logs" {
  statement {
    sid       = "1"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.symbolic_name}-logs/*"]
    principals {
      type        = "AWS"
      identifiers = ["797873946194"]
    }
  }
  statement {
    sid       = "2"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.symbolic_name}-logs/*"]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

