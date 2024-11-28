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

resource "aws_internet_gateway" "devops_internet_gateway" {
  vpc_id = aws_vpc.devops.id

  tags = {
    Name = "devops_internet_gateway"
  }
}

resource "aws_subnet" "us_east_1a_subnet" {
  vpc_id     = aws_vpc.devops.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "us_east_1a_subnet"
  }
}

resource "aws_subnet" "us_east_1b_subnet" {
  vpc_id     = aws_vpc.devops.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "us_east_1b_subnet"
  }
}

resource "aws_route_table" "devops_route_table" {
  vpc_id = aws_vpc.devops.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_internet_gateway.id
  }

  tags = {
    Name = "devops_route_table"
  }
}

resource "aws_route_table_association" "subnet-association-a" {
  subnet_id      = aws_subnet.us_east_1a_subnet.id
  route_table_id = aws_route_table.devops_route_table.id
}

resource "aws_route_table_association" "subnet-association-b" {
  subnet_id      = aws_subnet.us_east_1b_subnet.id
  route_table_id = aws_route_table.devops_route_table.id
}

resource "aws_lb" "devops_alb_products" {
  name               = "devops-alb-products"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group.id]
  subnets            = [aws_subnet.us_east_1a_subnet.id, aws_subnet.us_east_1b_subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "devops_tg_products" {
  name     = "devop-tg-products"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.devops.id
  target_type = "ip"

  health_check {
    path = "/products"
    port = 8080
  }
}

resource "aws_lb_listener" "devops_listener_products" {
  load_balancer_arn = aws_lb.devops_alb_products.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_tg_products.arn
  }
}

resource "aws_lb_listener_rule" "devops-products-rule" {
  listener_arn = aws_lb_listener.devops_listener_products.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_tg_products.arn
  }

  condition {
    path_pattern {
      values = ["/products"]
    }
  }
}

resource "aws_lb" "devops_alb_shipping" {
  name               = "devops-alb-shipping"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group.id]
  subnets            = [aws_subnet.us_east_1a_subnet.id, aws_subnet.us_east_1b_subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "devops_tg_shipping" {
  name     = "devop-tg-shipping"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.devops.id
  target_type = "ip"

  health_check {
    path = "/shipping/c"
    port = 8080
  }
}

resource "aws_lb_listener" "devops_listener_shipping" {
  load_balancer_arn = aws_lb.devops_alb_shipping.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_tg_shipping.arn
  }
}

resource "aws_lb_listener_rule" "devops-shipping-rule" {
  listener_arn = aws_lb_listener.devops_listener_shipping.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_tg_shipping.arn
  }

  condition {
    path_pattern {
      values = ["/shipping/c"]
    }
  }
}

resource "aws_lb" "devops_alb_payments" {
  name               = "devops-alb-payments"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group.id]
  subnets            = [aws_subnet.us_east_1a_subnet.id, aws_subnet.us_east_1b_subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "devops_tg_payments" {
  name     = "devop-tg-payments"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.devops.id
  target_type = "ip"

  health_check {
    path = "/payments"
    port = 8080
  }
}

resource "aws_lb_listener" "devops_listener_payments" {
  load_balancer_arn = aws_lb.devops_alb_payments.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_tg_payments.arn
  }
}

resource "aws_lb_listener_rule" "devops-payments-rule" {
  listener_arn = aws_lb_listener.devops_listener_payments.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_tg_payments.arn
  }

  condition {
    path_pattern {
      values = ["/payments"]
    }
  }
}

resource "aws_lb" "devops_alb_orders" {
  name               = "devops-alb-orders"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group.id]
  subnets            = [aws_subnet.us_east_1a_subnet.id, aws_subnet.us_east_1b_subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "devops_tg_orders" {
  name     = "devop-tg-orders"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.devops.id
  target_type = "ip"

  health_check {
    path = "/orders"
    port = 8080
  }
}

resource "aws_lb_listener" "devops_listener_orders" {
  load_balancer_arn = aws_lb.devops_alb_orders.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_tg_orders.arn
  }
}

resource "aws_lb_listener_rule" "devops-orders-rule" {
  listener_arn = aws_lb_listener.devops_listener_orders.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_tg_orders.arn
  }

  condition {
    path_pattern {
      values = ["/orders"]
    }
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

resource "aws_ecs_cluster" "devops_cluster" {
    name = "devops_ecs_cluster"

    setting {
        name  = "containerInsights"
        value = "enabled"
    }
}

resource "aws_ecs_task_definition" "devops_orders_task" {
    family = "orders"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 1024
    memory                   = 2048
    container_definitions = jsonencode([
        {
            name      = "orders"
            image     = "iribastrillo/orders-service"
            essential = true
            portMappings = [
                {
                protocol = "tcp"
                containerPort = 8080
                hostPort      = 8080
                }
            ]
        }
    ])
}

resource "aws_ecs_task_definition" "devops_products_task" {
    network_mode             = "awsvpc"
    family = "products"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 1024
    memory                   = 2048
    container_definitions = jsonencode([
        {
            name      = "products"
            image     = "iribastrillo/products-service"
            essential = true
            portMappings = [
                {
                protocol = "tcp"
                containerPort = 8080
                hostPort      = 8080
                }
            ]
        }
    ])
}


resource "aws_ecs_task_definition" "devops_shipping_task" {
    network_mode             = "awsvpc"
    family = "shipping"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 1024
    memory                   = 2048
    container_definitions = jsonencode([
        {
            name      = "shipping"
            image     = "iribastrillo/shipping-service"
            essential = true
            portMappings = [
                {
                protocol = "tcp"
                containerPort = 8080
                hostPort      = 8080
                }
            ]
        }
    ])
}

resource "aws_ecs_task_definition" "devops_payments_task" {
    network_mode             = "awsvpc"
    family = "payments"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 1024
    memory                   = 2048
    container_definitions = jsonencode([
        {
            name      = "payments"
            image     = "iribastrillo/payments-service"
            essential = true
            portMappings = [
                {
                protocol = "tcp"
                containerPort = 8080
                hostPort      = 8080
                }
            ]
        }
    ])
}

resource "aws_ecs_service" "orders_service" {
    name                               = "orders_service"
    cluster                            = aws_ecs_cluster.devops_cluster.id
    task_definition                    = aws_ecs_task_definition.devops_orders_task.arn
    desired_count                      = 2
    deployment_minimum_healthy_percent = 1
    deployment_maximum_percent         = 100
    launch_type                        = "FARGATE"
    scheduling_strategy                = "REPLICA"
    
    force_new_deployment = true

    load_balancer {
      target_group_arn = aws_lb_target_group.devops_tg_orders.arn
      container_name   = "orders"
      container_port   = 8080
    }

    network_configuration {
        subnets         = [aws_subnet.us_east_1a_subnet.id, aws_subnet.us_east_1b_subnet.id]
        security_groups = [aws_security_group.security_group.id]
        assign_public_ip = true
    }

    depends_on = [
        aws_ecs_task_definition.devops_orders_task
    ]
}

resource "aws_ecs_service" "payments_service" {
    name                               = "payments_service"
    cluster                            = aws_ecs_cluster.devops_cluster.id
    task_definition                    = aws_ecs_task_definition.devops_payments_task.arn
    desired_count                      = 2
    deployment_minimum_healthy_percent = 1
    deployment_maximum_percent         = 100
    launch_type                        = "FARGATE"
    scheduling_strategy                = "REPLICA"
    
    force_new_deployment = true

    load_balancer {
      target_group_arn = aws_lb_target_group.devops_tg_payments.arn
      container_name   = "payments"
      container_port   = 8080
    }

    network_configuration {
        subnets         = [aws_subnet.us_east_1a_subnet.id, aws_subnet.us_east_1b_subnet.id]
        security_groups = [aws_security_group.security_group.id]
        assign_public_ip = true
    }

    depends_on = [
        aws_ecs_task_definition.devops_payments_task
    ]
}

resource "aws_ecs_service" "products_service" {
    name                               = "products_service"
    cluster                            = aws_ecs_cluster.devops_cluster.id
    task_definition                    = aws_ecs_task_definition.devops_products_task.arn
    desired_count                      = 2
    deployment_minimum_healthy_percent = 1
    deployment_maximum_percent         = 100
    launch_type                        = "FARGATE"
    scheduling_strategy                = "REPLICA"
    
    force_new_deployment = true

    load_balancer {
      target_group_arn = aws_lb_target_group.devops_tg_products.arn
      container_name   = "products"
      container_port   = 8080
    }

    network_configuration {
        subnets         = [aws_subnet.us_east_1a_subnet.id, aws_subnet.us_east_1b_subnet.id]
        security_groups = [aws_security_group.security_group.id]
        assign_public_ip = true
    }

    depends_on = [
        aws_ecs_task_definition.devops_products_task
    ]
}

resource "aws_ecs_service" "shipping_service" {
    name                               = "shipping_service"
    cluster                            = aws_ecs_cluster.devops_cluster.id
    task_definition                    = aws_ecs_task_definition.devops_shipping_task.arn
    desired_count                      = 2
    deployment_minimum_healthy_percent = 1
    deployment_maximum_percent         = 100
    launch_type                        = "FARGATE"
    scheduling_strategy                = "REPLICA"
    
    force_new_deployment = true

    load_balancer {
      target_group_arn = aws_lb_target_group.devops_tg_shipping.arn
      container_name   = "shipping"
      container_port   = 8080
    }

    network_configuration {
        subnets         = [aws_subnet.us_east_1a_subnet.id, aws_subnet.us_east_1b_subnet.id]
        security_groups = [aws_security_group.security_group.id]
        assign_public_ip = true
    }

    depends_on = [
        aws_ecs_task_definition.devops_shipping_task
    ]
}