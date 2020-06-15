output "ec2_public_ip" {
  value = aws_instance.ubuntu_ec2_public.public_ip
}

output "ec2_private_instance_ip" {
  value = aws_instance.ubuntu_ec2_private.private_ip
}