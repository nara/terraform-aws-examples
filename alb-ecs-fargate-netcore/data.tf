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

data "template_file" "task_definition" {
  template = file("task-definition.json")
  vars = {
    image_url        = "mcr.microsoft.com/dotnet/core/samples:aspnetapp"
    container_name   = "dotnetappsample"
    log_group_region = "${var.aws_region}"
    log_group_name   = "${aws_cloudwatch_log_group.test_cw_container.name}"
  }
}