variable "aws_region" {
  description = "AWS region to launch components"
  default = "us-east-1"
}
variable "state_bucket"{
    description = "S3 bucket for terraform state"
    default = "terraform-aws-examples-state"
}

variable "state_dynamo_table"{
    description = "DynamoDB table name for terraform state"
    default = "terraform-aws-examples-state-locks"
}
