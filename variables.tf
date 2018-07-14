variable "default_sender_id" {
  description = "A custom ID, such as your business brand, displayed as the sender on the receiving device. Support for sender IDs varies by country."
  default     = ""
}

variable "default_sms_type" {
  description = "Promotional messages are noncritical, such as marketing messages. Transactional messages are delivered with higher reliability to support customer transactions, such as one-time passcodes."
  default     = "Promotional"
}

variable "delivery_status_iam_role_arn" {
  description = "The IAM role that allows Amazon SNS to write logs for SMS deliveries in CloudWatch Logs."
  default     = ""
}

variable "delivery_status_success_sampling_rate" {
  description = "Default percentage of success to sample."
  default     = ""
}

variable "monthly_spend_limit" {
  description = "The maximum amount to spend on SMS messages each month. If you send a message that exceeds your limit, Amazon SNS stops sending messages within minutes."
  default     = 1
}

variable "policy_name" {
  description = "Name of policy to publish to Group SMS topic."
  default     = "group-sms-publish"
}

variable "policy_path" {
  description = "Path of policy to publish to Group SMS topic"
  default     = "/"
}

variable "role_name" {
  description = "The IAM role that allows Amazon SNS to write logs for SMS deliveries in CloudWatch Logs."
  default     = "SNSSuccessFeedback"
}

variable "subscriptions" {
  description = "List of telephone numbers to subscribe to SNS."
  type        = "list"
  default     = []
}

variable "topic_display_name" {
  description = "Display name of the AWS SNS topic."
  default     = ""
}

variable "topic_name" {
  description = "Name of the AWS SNS topic."
}

variable "usage_report_s3_bucket" {
  description = "The Amazon S3 bucket to receive daily SMS usage reports. The bucket policy must grant write access to Amazon SNS."
}
