resource "aws_iam_role" "iam_for_lambda" {
  name = "security-group-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_for_lambda_policy" {
  name = "security-group-lambda-role-policy"
  role =  aws_iam_role.iam_for_lambda.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "ec2:DescribeSecurityGroups"
        ],
        "Resource": "*"
    },
    {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "sns:Publish"
        ],
        "Resource": [ "${aws_sns_topic.test_sns_topic.arn}" ]
    },
    {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": [
            "${aws_cloudwatch_log_group.cw_log_resource_group_lambda.arn}"
        ]
    }
  ]
}
EOF
}

locals {
    lambda_path = "./lambda_src/handler.zip"
}

resource "aws_lambda_function" "resource_group_lambda" {
    function_name = "lambda-resource-group-validation"
    filename = local.lambda_path
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    handler = "handler.lambda_handler"
    role = aws_iam_role.iam_for_lambda.arn
    runtime = "python3.7"
    depends_on = [aws_iam_role_policy.iam_for_lambda_policy, aws_cloudwatch_log_group.cw_log_resource_group_lambda]

    environment {
      variables = {
        sns_arn = aws_sns_topic.test_sns_topic.arn
      }
    }
}

resource "aws_cloudwatch_log_group" "cw_log_resource_group_lambda"{
  name = "/aws/lambda/lambda-resource-group-validation"
  retention_in_days = 1
}

resource "aws_lambda_permission" "resource_group_cw_permission" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.resource_group_lambda.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.cw_security_group_rule.arn
}