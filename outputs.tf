output "topic_arn" {
  value = "${aws_sns_topic.group_sms.arn}"
}
