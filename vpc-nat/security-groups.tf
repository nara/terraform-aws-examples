resource "aws_security_group" "test_sg_public" {
    description = "Security group for instances that are in public subnet"
    vpc_id = aws_vpc.test_vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.cidr_internet]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [var.cidr_internet]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.cidr_internet]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.cidr_internet]
    }

    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [var.cidr_internet]
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.vpc_cidr]
    }
}

resource "aws_security_group" "test_sg_private" {
    description = "Security group for instances that are in private subnet"
    vpc_id = aws_vpc.test_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.test_sg_public.id]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.cidr_internet]
    }

    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [var.cidr_internet]
    }
}