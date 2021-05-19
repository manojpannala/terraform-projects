provider "aws" {
  region = "eu-central-1"
}

variable vpc_cidr_block {
  description = "vpc cidr block"
}

variable subnet_cidr_block {
  description = "subnet cidr block"
}

variable avail_zone {}

variable env_prefix {}

variable myip {}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
    tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-main-rtb"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}

resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id
  ingress {
    cidr_blocks = [ var.myip ]
    description = "Ingress SSH"
    from_port = 22
    # ipv6_cidr_blocks = [ "value" ]
    # prefix_list_ids = [ "value" ]
    protocol = "tcp"
    # security_groups = [ "value" ]
    # self = false
    to_port = 22
  } 

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Ingress Nginx"
    from_port = 8080
    # ipv6_cidr_blocks = [ "value" ]
    # prefix_list_ids = [ "value" ]
    protocol = "tcp"
    # security_groups = [ "value" ]
    # self = false
    to_port = 8080
  } 

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Egress Nginx"
    from_port = 0
    # ipv6_cidr_blocks = [ "value" ]
    prefix_list_ids = []
    protocol = "-1"
    # security_groups = [ "value" ]
    # self = false
    to_port = 0
  } 
  
  tags = {
    Name: "${var.env_prefix}-sg"
  }

}