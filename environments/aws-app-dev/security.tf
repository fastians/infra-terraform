locals {
  dev_ingress_rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH"
    }
    grafana = {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = [var.ingress_source_cidr]
      description = "Grafana"
    }
    loki = {
      from_port   = 3100
      to_port     = 3100
      protocol    = "tcp"
      cidr_blocks = [var.ingress_source_cidr]
      description = "Loki"
    }
    prometheus = {
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = [var.ingress_source_cidr]
      description = "Prometheus"
    }
    alertmanager = {
      from_port   = 9093
      to_port     = 9093
      protocol    = "tcp"
      cidr_blocks = [var.ingress_source_cidr]
      description = "Alertmanager"
    }
  }
}

module "security" {
  source = "../../modules/security-rules"

  name          = "aws-app-dev-access"
  description   = "SSH and monitoring stack (Grafana, Loki, Prometheus, Alertmanager)"
  vpc_id        = module.network.vpc_id
  ingress_rules = local.dev_ingress_rules
}
