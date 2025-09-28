output "ecr_repository_url" {
  value = aws_ecr_repository.admin_portal.repository_url
}

output "ecs_service_url" {
  value = "http://${aws_ecs_service.admin_portal.load_balancer[0].dns_name}:8000"
}

output "database_endpoint" {
  value = aws_db_instance.admin_portal.endpoint
}
