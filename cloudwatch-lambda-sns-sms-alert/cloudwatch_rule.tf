resource "aws_cloudwatch_event_rule" "cw_security_group_rule" {
  name        = "cw-security-group-rule"
  description = "Capture security group rule changes and invoke lambda for validation"

  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ec2.amazonaws.com"
    ],
    "eventName": [
      "AuthorizeSecurityGroupIngress",
      "RevokeSecurityGroupIngress"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "cw_security_group_rule_lambda_target" {
    rule      =  aws_cloudwatch_event_rule.cw_security_group_rule.name
    target_id = "SendToLambda"
    arn = aws_lambda_function.resource_group_lambda.arn
}

resource "aws_iam_role" "lamdba_role" {
  name = "cw-rule-to-lamdba-target-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lamdba_role_policy_attachment" {
  role = aws_iam_role.lamdba_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}