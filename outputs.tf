output "topic_arn" {
  description = "AWS Topic ARN."
  value       = "${aws_sns_topic.group_sms.arn}"
}

output "topic_subscriptions" {
  description = "Subscriptions to SNS Topic."
  value       = "${aws_sns_topic_subscription.group_sms.*.endpoint}"
}
