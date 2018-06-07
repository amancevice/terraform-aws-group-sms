output "topic_arn" {
  description = "AWS Topic ARN."
  value       = "${aws_sns_topic.sms.arn}"
}
