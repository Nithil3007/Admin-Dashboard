# ============================================================================
# RDS - PostgreSQL Database
# ============================================================================

resource "aws_db_subnet_group" "admin_portal" {
  name       = "admin-portal-db-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name        = "admin-portal-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds" {
  name        = "admin-portal-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from App Runner"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.apprunner.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "admin-portal-rds-sg"
    Environment = var.environment
  }
}

resource "aws_db_instance" "admin_portal" {
  identifier     = "admin-portal-db"
  engine         = "postgres"
  engine_version = "13.13"
  instance_class = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = "admin_portal"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.admin_portal.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"

  skip_final_snapshot       = true
  final_snapshot_identifier = "admin-portal-final-snapshot"
  deletion_protection       = false

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = {
    Name        = "admin-portal-db"
    Environment = var.environment
  }
}
