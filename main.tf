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
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.our_iGateway.id
  }
  tags = {
      Name = "our_route_table"
  }  
}

# Create a Route Association 
resource "aws_route_table_association" "our_association_subnet" {
    subnet_id = aws_subnet.subnet0.id
    route_table_id = aws_route_table.our_route_table.id
}

# Create a Security Group
resource "aws_security_group" "allow_80" {
  name = "allow_80"
  description = "allows HTTP: 80"
  vpc_id = aws_vpc.SR_VPC.id
  
  ingress {
      description = "HTTP: 80 from VPC"
        from_port = 80
          to_port = 80
         protocol = "tcp"
      cidr_blocks = [aws_vpc.SR_VPC.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
      Name = "allow_80"
  }
}