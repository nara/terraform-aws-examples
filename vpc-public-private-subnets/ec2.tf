resource "aws_key_pair" "generated_key" {
  key_name   = "sshkey"
  public_key = var.ssh_public_key
}

resource "aws_instance" "ubuntu_ec2_private"{
    ami = data.aws_ami.canonical_ubuntu.id
    instance_type = "t1.micro"
    key_name  = aws_key_pair.generated_key.key_name
    subnet_id = aws_subnet.test_subnet_private.id
    associate_public_ip_address = false
    security_groups = [aws_security_group.test_sg_private.id]
}

resource "aws_instance" "ubuntu_ec2_public"{
    ami = data.aws_ami.canonical_ubuntu.id
    instance_type = "t1.micro"

    security_groups = [aws_security_group.test_sg_public.id]
    subnet_id = aws_subnet.test_subnet_public.id
    associate_public_ip_address = true
    key_name  = aws_key_pair.generated_key.key_name
    user_data = <<EOF
		#!/bin/bash -v
        echo "userdata-start"
        sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
        echo "userdata-end"
	EOF
}

