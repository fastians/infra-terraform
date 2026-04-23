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
      description = "App ports"
    }
    grafana = {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = var.allowed_monitoring_cidrs
      description = "Grafana"
    }
    loki = {
      from_port   = 3100
      to_port     = 3100
      protocol    = "tcp"
      cidr_blocks = var.allowed_monitoring_cidrs
      description = "Loki"
    }
    prometheus = {
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = var.allowed_monitoring_cidrs
      description = "Prometheus"
    }
    alertmanager = {
      from_port   = 9093
      to_port     = 9093
      protocol    = "tcp"
      cidr_blocks = var.allowed_monitoring_cidrs
      description = "Alertmanager"
    }
    blackbox = {
      from_port   = 9115
      to_port     = 9115
      protocol    = "tcp"
      cidr_blocks = var.allowed_monitoring_cidrs
      description = "Blackbox Exporter"
    }
  }
}
