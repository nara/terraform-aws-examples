provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "terraform-aws-examples-state"
    key            = "global/s3/vpc-private-public-subnet/terraform.tfstate"
    region         = "us-east-1"
    
    dynamodb_table = "terraform-aws-examples-state-locks"
    encrypt        = true
  }
}