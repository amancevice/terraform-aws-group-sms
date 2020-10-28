# AWS Group SNS

Send SMS messages to a group via AWS SNS

## Terraform versions

For Terraform versions >= 0.12 use versions tagged 0.5.0 or later, for
Terraform 0.11 use 0.4.0.

## Quickstart

Create a `main.tf` file with the following contents:

```terraform
# main.tf

module "group_sms" {
  source                 = "amancevice/group-sms/aws"
  monthly_spend_limit    = 100
  topic_name             = "my-topic"
  topic_display_name     = "MyTopic"
  usage_report_s3_bucket = "<my-sms-usage-bucket>"

  subscriptions = [
    "+19876543210",
    "+12345678910",
    "+15555555555",
    "..."
  ]
}
```

## AWS $1 Limit

The catch to all this is that Amazon imposes a strict $1/month limit on SMS messages. The only way to raise that limit is to make a request to Amazon and wait for them to allow you to spend over that limit.

### Raising Your $1 Limit

Raising your SMS limit is as simple as filing a support ticket with AWS. When I opened mine I was contacted within a few days by an Amazon Rep.

Our limit was increased to the desired amount after answering the following questions for the Rep:

>The spending limit you are requesting, in US dollars.

It's probably best for you to do some back-of-the-envelope calculations for this. How many texts will you send per month? To how many people? Try to overshoot by a large margin so that you don't have to do this again.

>A list of countries in which the recipients of your messages are located.

We have some members with Canadian phone numbers (apparently) so I indicated that we would be contacting US & Canadian phones to be on the safe side.

>Information about the type of messages you will be sending (Transactional, Promotional, One-Time Password, etc.)

Promotional messages are what you are looking for here.

>The maximum number of messages you expect to send per day.

We have no intention of spamming our members, so I said "between 0–2 per day, mostly 0" to give some wiggle-room.

>What is the name of the website, application, or other entity that will be sending SMS messages? Please provide a link.

I explained that the messages would originate from our private Slack workspace.

>Explain the opt-in process to receive your messages.

Here I explained that members are given the opportunity to provide a phone number when they join the org as dues-paying members.

>Describe the primary function of your site or application and how SMS will be incorporated.

This one is up to you.

>Details of the ways in which you will ensure you are only sending to people who have requested your messages.

Again I explained that we only have contact info for members in good standing and that we would be respecting Amazon's built-in opt-out protocols.

Users who respond to any SMS with `STOP`, `UNSUBSCRIBE`, `END`, etc are automatically removed from distribution.
