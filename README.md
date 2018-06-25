# AWS Group SNS

Send SMS messages to a group via AWS SNS

## Quickstart

Create a `main.tf` file with the following contents:

```terraform
# main.tf

module "group_sms" {
  source             = "amancevice/group-sms/aws"
  topic_display_name = "MyTopic"
  topic_name         = "my-topic"

  subscriptions = [
    "+19876543210",
    "+12345678910",
    "+15555555555",
    "..."
  ]
}
```

In a terminal window, initialize the state:

```bash
terraform init
```

Then review & apply the changes

```bash
terraform apply
```
