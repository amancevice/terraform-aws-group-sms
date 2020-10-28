locals {
  display_name = coalesce(var.topic_display_name, var.topic_name)
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "delivery_status_role_inline_policy" {
  statement {
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy",
    ]
  }
}

data "aws_iam_policy_document" "delivery_status_bucket_policy" {
  policy_id = "sns-sms-daily-usage-policy"

  statement {
    sid       = "AllowPutObject"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.delivery_status_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }

  statement {
    sid       = "AllowGetBucketLocation"
    actions   = ["s3:GetBucketLocation"]
    resources = [aws_s3_bucket.delivery_status_bucket.arn]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "publish" {
  statement {
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.topic.arn]
  }
}

resource "aws_iam_policy" "publish" {
  name        = var.policy_name
  path        = var.policy_path
  description = "Allow publishing to Group SMS SNS Topic"
  policy      = data.aws_iam_policy_document.publish.json
}

resource "aws_iam_role" "delivery_status_role" {
  description        = "Allow AWS to publish SMS delivery status logs"
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "delivery_status_role_inline_policy" {
  name   = "${aws_iam_role.delivery_status_role.name}InlinePolicy"
  role   = aws_iam_role.delivery_status_role.id
  policy = data.aws_iam_policy_document.delivery_status_role_inline_policy.json
}

resource "aws_s3_bucket" "delivery_status_bucket" {
  bucket = var.usage_report_s3_bucket
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "delivery_status_bucket_policy" {
  bucket = aws_s3_bucket.delivery_status_bucket.bucket
  policy = data.aws_iam_policy_document.delivery_status_bucket_policy.json
}

resource "aws_sns_sms_preferences" "sms_preferences" {
  default_sender_id                     = var.default_sender_id
  default_sms_type                      = var.default_sms_type
  delivery_status_iam_role_arn          = aws_iam_role.delivery_status_role.arn
  delivery_status_success_sampling_rate = var.delivery_status_success_sampling_rate
  monthly_spend_limit                   = var.monthly_spend_limit
  usage_report_s3_bucket                = aws_s3_bucket.delivery_status_bucket.bucket
}

resource "aws_sns_topic" "topic" {
  display_name = local.display_name
  name         = var.topic_name
}

resource "aws_sns_topic_subscription" "subscription" {
  count     = length(var.subscriptions)
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "sms"
  endpoint  = element(var.subscriptions, count.index)
}

