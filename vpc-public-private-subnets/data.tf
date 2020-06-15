data "aws_availability_zones" "available_zones" {}

data "aws_ami" "canonical_ubuntu" {
  most_recent = true

  filter {
    name   = "description"
    values = ["Canonical, Ubuntu Minimal, 18.04 LTS*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

