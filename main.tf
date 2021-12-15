terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "SR_VPC" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "SR_VPC"
  }
}

# Create a subnet
resource "aws_subnet" "subnet0" {
  vpc_id = aws_vpc.SR_VPC.id
  cidr_block = "10.0.1.0/24"
  tags = {
      Name = "our_subnet"
  }
}

# Create a Internet Gateway
resource "aws_internet_gateway" "our_iGateway" {
    vpc_id = aws_vpc.SR_VPC.id
    tags = {
        Name = "our_iGateway"
    }
}

# Create a Route Table
resource "aws_route_table" "our_route_table" {
  vpc_id = aws_vpc.SR_VPC.id
  route {
      cidr_block = "10.0.1.0/24"
      gateway_id = aws_internet_gateway.our_iGateway.id
  }
  tags = {
      Name = "our_route_table"
  }  
}

