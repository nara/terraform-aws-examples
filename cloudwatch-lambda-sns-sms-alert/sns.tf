resource aws_sns_topic test_sns_topic {
    name = "test-sns-topic"
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.test_sns_topic.arn
  protocol  = "sms"
  endpoint  = var.phone_number
}