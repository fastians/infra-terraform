resource "aws_security_group" "monitoring" {
  name        = "aws-dev-monitoring"
  description = "SSH and monitoring stack (Grafana, Loki, Prometheus, Alertmanager)"
  vpc_id      = aws_vpc.main.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  # Grafana
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.ingress_source_cidr]
    description = "Grafana"
  }

  # Loki
  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = [var.ingress_source_cidr]
    description = "Loki"
  }

  # Prometheus
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.ingress_source_cidr]
    description = "Prometheus"
  }

  # Alertmanager
  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = [var.ingress_source_cidr]
    description = "Alertmanager"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound"
  }

  tags = {
    Name = "aws-dev-monitoring"
  }
}
