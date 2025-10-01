# ============================================================================
# AMPLIFY - Frontend Hosting
# ============================================================================

resource "aws_amplify_app" "admin_portal" {
  name       = "admin-portal-frontend"
  repository = var.github_repository_url

  # Build settings for Next.js
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: .next
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # Environment variables for frontend
  environment_variables = {
    NEXT_PUBLIC_COGNITO_USER_POOL_ID = aws_cognito_user_pool.admin_portal.id
    NEXT_PUBLIC_COGNITO_CLIENT_ID    = aws_cognito_user_pool_client.admin_portal.id
    NEXT_PUBLIC_AWS_REGION           = var.aws_region
    NEXT_PUBLIC_ADMIN_API_URL        = "https://${aws_apprunner_service.admin_portal.service_url}"
  }

  # Enable auto branch creation
  enable_branch_auto_build    = true
  enable_branch_auto_deletion = true

  # Custom rules for Next.js routing
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }

  tags = {
    Name        = "admin-portal-frontend"
    Environment = var.environment
  }
}

# Amplify Branch (main branch)
resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.admin_portal.id
  branch_name = var.github_branch_name

  enable_auto_build = true

  tags = {
    Name        = "admin-portal-main-branch"
    Environment = var.environment
  }
}
