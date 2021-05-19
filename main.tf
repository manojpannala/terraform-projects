provider "aws" {
  region = "eu-central-1"
}

variable subnet_cidr_block {
  description = "subnet cidr block"
}
variable vpc_cidr_block {
  description = "vpc cidr block"
}
variable avail_zone {}



resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: var.cidr_blocks[0].name
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
    tags = {
    Name: var.cidr_blocks[0].name
  }
}