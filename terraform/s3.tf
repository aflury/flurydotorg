resource aws_s3_bucket "flurydotorg-tfstate" {
  bucket = "flurydotorg-tfstate"
  tags   = {}
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource aws_s3_bucket "flurydotorg_logs" {
  bucket        = "flurydotorg-logs"
  tags          = {}

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
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::flurydotorg-logs/*",
      "Principal": {
        "AWS": [
          "797873946194"
        ]
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::flurydotorg-logs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::flurydotorg-logs"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "flurydotorg_resume" {
  bucket        = "flurydotorg-resume"
  tags          = {}
}