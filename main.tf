terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 3.21"
    }
  }
}

provider "aws" {
  region = "us-east-1"  
  profile = "default" 
}

resource "aws_vpc" "devops" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "devops"
  }
}

resource "aws_subnet" "us-east-1a-subnet" {
  vpc_id     = aws_vpc.devops.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "us-east-1a-subnet"
  }
}

resource "aws_subnet" "us-east-1b-subnet" {
  vpc_id     = aws_vpc.devops.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "us-east-1b-subnet"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.devops.id

  tags = {
    Name = "devops-internet-gateway"
  }
}

resource "aws_route_table" "devops_route_table" {
  vpc_id = aws_vpc.devops.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "devops-route-table"
  }
}

resource "aws_route_table_association" "subnet-association-a" {
  subnet_id      = aws_subnet.us-east-1a-subnet.id
  route_table_id = aws_route_table.devops_route_table.id
}

resource "aws_route_table_association" "subnet-association-b" {
  subnet_id      = aws_subnet.us-east-1b-subnet.id
  route_table_id = aws_route_table.devops_route_table.id
}

resource "aws_security_group" "security_group" {
 name   = "ecs-security-group"
 vpc_id = aws_vpc.devops.id

 ingress {
   from_port   = 0
   to_port     = 0
   protocol    = -1
   self        = "false"
   cidr_blocks = ["0.0.0.0/0"]
   description = "any"
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}