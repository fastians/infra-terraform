resource "aws_ecr_repository" "salome" {
  name                 = "mek-lab/salome"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-salome-ecr" })
}

resource "aws_ecr_lifecycle_policy" "salome" {
  repository = aws_ecr_repository.salome.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = { type = "expire" }
    }]
  })
}

output "salome_ecr_url" {
  description = "ECR repository URL for salome image"
  value       = aws_ecr_repository.salome.repository_url
}
