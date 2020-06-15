# cloudwatch-sns-lambda-alert
This terraform example builds a cloudwatch rule that gets triggerred when anyone changes a security group, and calls a python lambda function that validates if the change is permitted based on company policy, and sends a message to SNS so an email can be sent administrator about violation.

It sets up a cloud trail and configures to log to cloudwatch. Terraform destroy will remove the cloud trail.