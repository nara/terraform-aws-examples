resource "aws_cloudtrail" "cloudtrail_sample" {
  name                          = "tf-trail-for-cloudwatch-monitoring"
  s3_bucket_name                =  aws_s3_bucket.cloud_trail_log.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.cloud_trail_log.arn
  cloud_watch_logs_role_arn = aws_iam_role.cloud_trail_to_cloud_watch_role.arn

  depends_on = [
    aws_iam_role_policy.cloud_trail_to_cloud_watch_role_policy
  ]
}

locals {
    s3_bucket_name = "tf-test-cloud-trail-log-987654"
}

resource "aws_s3_bucket" "cloud_trail_log" {
  bucket        = local.s3_bucket_name
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${local.s3_bucket_name}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.s3_bucket_name}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_cloudwatch_log_group" "cloud_trail_log"{
  name = "cloud-trail-log"
}

resource "aws_iam_role" "cloud_trail_to_cloud_watch_role" {
  name = "cloud-trail-to-cloud-watch-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloud_trail_to_cloud_watch_role_policy" {
  name = "cloud-trail-to-cloud-watch-role-policy"
  role =  aws_iam_role.cloud_trail_to_cloud_watch_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogStream"
        ],
        "Resource": [
            "${aws_cloudwatch_log_group.cloud_trail_log.arn}"
        ]
    },
    {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "logs:PutLogEvents"
        ],
        "Resource": [
            "${aws_cloudwatch_log_group.cloud_trail_log.arn}"
        ]
    }
  ]
}
EOF
}