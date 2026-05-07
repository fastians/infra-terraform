locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )

  # Shared SG: backend uses 8000-8002, salome uses 8000.
  # Monitoring agent ports (node_exporter, etc.) are also allowed for Prometheus scrape.
  ingress_rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidrs
      description = "SSH"
    }
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_http_cidrs
      description = "HTTP"
    }
    https = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.allowed_http_cidrs
      description = "HTTPS"
    }
    app = {
      from_port   = 8000
      to_port     = 8002
      protocol    = "tcp"
      cidr_blocks = var.allowed_app_cidrs
      description = "App ports (backend 8000-8002, salome 8000)"
    }
    node_exporter = {
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      cidr_blocks = var.allowed_monitoring_cidrs
      description = "node_exporter (Prometheus scrape)"
    }
    promtail = {
      from_port   = 9080
      to_port     = 9080
      protocol    = "tcp"
      cidr_blocks = var.allowed_monitoring_cidrs
      description = "promtail metrics"
    }
  }
}
