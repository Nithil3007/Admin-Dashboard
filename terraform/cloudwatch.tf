# ============================================================================
# CLOUDWATCH - Logging
# ============================================================================

# CloudWatch Log Group for App Runner
resource "aws_cloudwatch_log_group" "apprunner" {
  name              = "/aws/apprunner/${aws_apprunner_service.admin_portal.service_name}"
  retention_in_days = 7

  tags = {
    Name        = "admin-portal-apprunner-logs"
    Environment = var.environment
  }
}

# CloudWatch Log Group for RDS
resource "aws_cloudwatch_log_group" "rds" {
  name              = "/aws/rds/instance/${aws_db_instance.admin_portal.identifier}/postgresql"
  retention_in_days = 7

  tags = {
    Name        = "admin-portal-rds-logs"
    Environment = var.environment
  }
}
