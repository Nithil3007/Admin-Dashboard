# ============================================================================
# OUTPUTS
# ============================================================================

#output "cognito_user_pool_id" {
#  value       = aws_cognito_user_pool.admin_portal.id
#  description = "Cognito User Pool ID"
#}

#output "cognito_client_id" {
#  value       = aws_cognito_user_pool_client.admin_portal.id
#  description = "Cognito User Pool Client ID"
#}

output "ecr_repository_url" {
  value       = aws_ecr_repository.admin_portal.repository_url
  description = "ECR repository URL for Docker images"
}

output "apprunner_service_url" {
  value       = aws_apprunner_service.admin_portal.service_url
  description = "App Runner service URL (HTTPS enabled)"
}

#output "database_endpoint" {
#  value       = aws_db_instance.admin_portal.endpoint
#  description = "RDS PostgreSQL endpoint"
#  sensitive   = true
#}

#output "s3_bucket_name" {
#  value       = aws_s3_bucket.transcriptions.id
#  description = "S3 bucket for transcription files"
#}

output "amplify_app_id" {
  value       = aws_amplify_app.admin_portal.id
  description = "Amplify App ID"
}

output "amplify_default_domain" {
  value       = aws_amplify_app.admin_portal.default_domain
  description = "Amplify default domain"
}

#output "vpc_id" {
#  value       = aws_vpc.main.id
#  description = "VPC ID"
#}
