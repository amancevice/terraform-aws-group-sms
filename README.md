# AWS Group SNS

Send SMS messages to a group via AWS SNS

```terraform
# terraform.tf

module "group_sms" {
  source             = "amancevice/group-sms/aws"
  version            = "<version>"
  topic_display_name = "MyTopic"
  topic_name         = "my-topic"

  subscriptions = [
    "+19876543210",
    "+12345678910",
    "+15555555555",
    "..."
  ]
}

output "sns_topic_arn" {
  description = "AWS Topic ARN."
  value       = "${module.group_sms.topic_arn}"
}

output "sns_topic_subscriptions" {
  description = "AWS Topic ARN."
  value       = "${module.group_sms.topic_subscriptions}"
}
```
