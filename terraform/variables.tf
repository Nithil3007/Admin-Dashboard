variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"
}

variable "db_username" {
  type        = string
  description = "Database username"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

variable "github_repository_url" {
  type        = string
  description = "GitHub repository URL for Amplify"
}

variable "github_branch_name" {
  type        = string
  description = "GitHub branch name for Amplify"
  default     = "main"
}
