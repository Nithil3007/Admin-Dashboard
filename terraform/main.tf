terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "admin_portal" {
  name = "admin-portal"
}

resource "aws_ecs_cluster" "admin_portal" {
  name = "admin-portal-cluster"
}

resource "aws_ecs_task_definition" "admin_portal" {
  family                   = "admin-portal"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
  container_definitions = jsonencode([
    {
      name      = "admin-portal"
      image     = "${aws_ecr_repository.admin_portal.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "admin_portal" {
  name            = "admin-portal-service"
  cluster         = aws_ecs_cluster.admin_portal.id
  task_definition = aws_ecs_task_definition.admin_portal.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.admin_portal.id]
    assign_public_ip = true
  }
}

resource "aws_db_instance" "admin_portal" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13.7"
  instance_class       = "db.t3.micro"
  name                 = "admin_portal"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
}
