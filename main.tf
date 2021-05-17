provider "aws" {
  region = "eu-central-1"
}

variable "subnet_cidr_block" {
  description = "subnet cidr block"
}
variable "vpc_cidr_block" {
  description = "vpc cidr block"
}
variable "environment" {
  description = "development environment"
}


resource "aws_vpc" "development-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "development",
    # vpc_env: "dev"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_block
    tags = {
    Name: "subnet-dev-1"
  }
}

data "aws_vpc" "existing-vpc" {
  default = true
}

# SUBNET-2
# resource "aws_subnet" "dev-subnet-2" {
#   vpc_id = data.aws_vpc.existing-vpc.id
#   cidr_block = var.subnet_cidr_block
#   availability_zone = "eu-central-1b"
#     tags = {
#     Name: "subnet-dev-2"
#   }
# }

output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}