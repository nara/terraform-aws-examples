resource "aws_vpc" "test_vpc" {
    cidr_block = var.vpc_cidr
    
    tags = {
        Name = "tf-vpc-private-public-subnet-example"
    }
}

resource "aws_internet_gateway" "test_igw" {
    vpc_id = aws_vpc.test_vpc.id
}

#public subnet
resource "aws_subnet" "test_subnet_public" {

    availability_zone = data.aws_availability_zones.available_zones.names[1]

    vpc_id = aws_vpc.test_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 4, 2)

    tags = {
        Name = "tf-vpc-private-public-subnet-example"
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
    route_table_id = aws_route_table.test_rt_public.id
    subnet_id = aws_subnet.test_subnet_public.id
}

#private subnet
resource "aws_subnet" "test_subnet_private" {

    availability_zone = data.aws_availability_zones.available_zones.names[0]

    vpc_id = aws_vpc.test_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 4, 1)

    tags = {
        Name = "tf-vpc-private-public-subnet-example"
    }
}

