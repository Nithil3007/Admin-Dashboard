# ============================================================================
# APP RUNNER - Backend API
# ============================================================================

# Security group for App Runner VPC connector
resource "aws_security_group" "apprunner" {
  name        = "admin-portal-apprunner-sg"
  description = "Security group for App Runner VPC connector"
  vpc_id      = aws_vpc.main.id

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "admin-portal-apprunner-sg"
    Environment = var.environment
  }
}

# VPC Connector for App Runner to access RDS
resource "aws_apprunner_vpc_connector" "main" {
  vpc_connector_name = "admin-portal-vpc-connector"
  subnets            = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  security_groups    = [aws_security_group.apprunner.id]

  tags = {
    Name        = "admin-portal-vpc-connector"
    Environment = var.environment
  }
}

# IAM Role for App Runner to access ECR
resource "aws_iam_role" "apprunner_service_role" {
  name = "admin-portal-apprunner-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "build.apprunner.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "admin-portal-apprunner-service-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_access" {
  role       = aws_iam_role.apprunner_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

# IAM Role for App Runner instance (to access S3, CloudWatch, etc.)
resource "aws_iam_role" "apprunner_instance_role" {
  name = "admin-portal-apprunner-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "tasks.apprunner.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "admin-portal-apprunner-instance-role"
    Environment = var.environment
  }
}

# Policy for App Runner to access S3
resource "aws_iam_role_policy" "apprunner_s3_access" {
  name = "apprunner-s3-access"
  role = aws_iam_role.apprunner_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ]
      Resource = [
        aws_s3_bucket.transcriptions.arn,
        "${aws_s3_bucket.transcriptions.arn}/*"
      ]
    }]
  })
}

# Policy for App Runner to write CloudWatch logs
resource "aws_iam_role_policy_attachment" "apprunner_cloudwatch_logs" {
  role       = aws_iam_role.apprunner_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# App Runner Service
resource "aws_apprunner_service" "admin_portal" {
  service_name = "admin-portal-backend"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_service_role.arn
    }

    image_repository {
      image_identifier      = "${aws_ecr_repository.admin_portal.repository_url}:latest"
      image_repository_type = "ECR"

      image_configuration {
        port = "8000"

        runtime_environment_variables = {
          DATABASE_URL = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.admin_portal.endpoint}/admin_portal"
          AWS_REGION   = var.aws_region
          S3_BUCKET    = aws_s3_bucket.transcriptions.id
        }
      }
    }

    auto_deployments_enabled = true
  }

  instance_configuration {
    cpu               = "0.25 vCPU"
    memory            = "0.5 GB"
    instance_role_arn = aws_iam_role.apprunner_instance_role.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.main.arn
    }
  }

  health_check_configuration {
    protocol            = "HTTP"
    path                = "/admin/users/stats"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 1
    unhealthy_threshold = 5
  }

  tags = {
    Name        = "admin-portal-backend"
    Environment = var.environment
  }
}
