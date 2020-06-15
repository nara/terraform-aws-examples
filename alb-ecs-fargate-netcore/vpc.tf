resource "aws_vpc" "test_vpc" {
    cidr_block = var.vpc_cidr
    
    tags = {
        Name = "vpc-alb-ecs-fargate"
    }
}

resource "aws_internet_gateway" "test_igw" {
    vpc_id = aws_vpc.test_vpc.id
}

#public subnet
resource "aws_subnet" "test_subnets" {

    count = var.az_count

    availability_zone = data.aws_availability_zones.available_zones.names[count.index]
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)

    tags = {
        Name = "vpc-alb-ecs-fargate-subnet-${count.index}"
    }
}

resource "aws_route_table" "test_rt_public" {
    vpc_id = aws_vpc.test_vpc.id
    
    route {
        cidr_block = var.cidr_internet
        gateway_id = aws_internet_gateway.test_igw.id
    }
}

resource "aws_route_table_association" "test_rta_public" {
    count = var.az_count
    route_table_id = aws_route_table.test_rt_public.id
    subnet_id = element(aws_subnet.test_subnets.*.id, count.index)
}
