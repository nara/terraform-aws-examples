variable "aws_region" {
  description = "AWS region to launch components"
  default = "us-east-1"
}
variable "state_bucket"{
    description = "S3 bucket for terraform state"
    default = "terraform-aws-examples-state"
}
variable "state_bucket_key"{
    description = "S3 bucket key for terraform state"
    default = "global/s3/vpc-private-public-subnet/terraform.tfstate"
}
variable "state_dynamo_table"{
    description = "DynamoDB table name for terraform state"
    default = "terraform-aws-examples-state-locks"
}
variable "vpc_cidr" {
    description = "CIDR block for VPC"
    default = "10.0.0.0/16"
}
variable "cidr_internet"{
    description = "Cidr block representing internet address"
    default = "0.0.0.0/0"
}
variable "cidr_local"{
    description = "Cidr block representing local address"
}
variable "ssh_public_key"{
    description = "ssh public key generated for EC2 instances."
}
variable "ssh_priate_key"{
    description = "ssh private key generated for EC2 instances."
}