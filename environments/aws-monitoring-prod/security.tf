locals {
  monitoring_ingress_rules = {
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
    blackbox_exporter = {
      from_port   = 9115
      to_port     = 9115
      protocol    = "tcp"
      cidr_blocks = [var.ingress_source_cidr]
      description = "Blackbox exporter"
    }
    node_exporter = {
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      cidr_blocks = [var.ingress_source_cidr]
      description = "Node exporter on monitor"
    }
  }
}

module "security" {
  source = "../../modules/security-rules"

  name          = "aws-monitoring-prod"
  description   = "SSH and full monitoring stack (Grafana, Loki, Prometheus, Alertmanager, Blackbox, node_exporter)"
  vpc_id        = module.network.vpc_id
  ingress_rules = local.monitoring_ingress_rules
}
