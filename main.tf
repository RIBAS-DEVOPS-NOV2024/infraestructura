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

resource "aws_subnet" "main-us-east-1a" {
  vpc_id     = aws_vpc.devops.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "main-us-east-1a"
  }
}

resource "aws_subnet" "main-us-east-1b" {
  vpc_id     = aws_vpc.devops.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "main-us-east-1b"
  }
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

resource "aws_ecs_cluster" "ecs_devops_cluster" {
  name = "devops_cluster"
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.ecs_devops_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "microservices" {
  family = "microservices"
  network_mode             = "awsvpc"
  cpu       = 1024
  memory    = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name      = "products-service"
      image     = "iribastrillo/products-service"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
  ])
}

resource "aws_ecs_service" "products_service" {
  name            = "products_service"
  cluster         = aws_ecs_cluster.ecs_devops_cluster.id
  task_definition = aws_ecs_task_definition.microservices.arn
  desired_count   = 2

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  network_configuration {
    subnets = aws_subnet.main-us-east-1a.id
    security_groups = aws_security_group.security_group.id
  }
}