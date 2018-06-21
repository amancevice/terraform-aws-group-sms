data "aws_iam_policy_document" "assume_role" {
  statement {
    actions    = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    resources = ["*"]
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy"
    ]
  }
}

resource "aws_iam_role" "role" {
  name               = "${var.role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_role_policy" "role_policy" {
  name   = "${aws_iam_role.role.name}Policy"
  role   = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_sns_sms_preferences" "sms_preferences" {
  default_sender_id                     = "${var.default_sender_id}"
  default_sms_type                      = "${var.default_sms_type}"
  delivery_status_iam_role_arn          = "${aws_iam_role.role.arn}"
  delivery_status_success_sampling_rate = "${var.delivery_status_success_sampling_rate}"
  monthly_spend_limit                   = "${var.monthly_spend_limit}"
  usage_report_s3_bucket                = "${var.usage_report_s3_bucket}"
}

resource "aws_sns_topic" "topic" {
  display_name = "${var.topic_display_name}"
  name         = "${var.topic_name}"
}

resource "aws_sns_topic_subscription" "subscription" {
  count     = "${length("${var.subscriptions}")}"
  topic_arn = "${aws_sns_topic.topic.arn}"
  protocol  = "sms"
  endpoint  = "${element("${var.subscriptions}", count.index)}"
}
