# ============================================================================
# ECR - Docker Image Repository
# ============================================================================

resource "aws_ecr_repository" "admin_portal" {
  name                 = "admin-portal"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "admin-portal-ecr"
    Environment = var.environment
  }
}

resource "aws_ecr_lifecycle_policy" "admin_portal" {
  repository = aws_ecr_repository.admin_portal.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}
