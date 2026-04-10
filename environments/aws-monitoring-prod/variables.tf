variable "aws_region" {
  description = "AWS region (use same region as prod app servers for lower latency and simpler SG rules)"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the monitoring VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the monitoring public subnet."
  type        = string
  default     = "10.1.1.0/24"
}

variable "key_name" {
  description = "EC2 key pair name (must match the private key you use in Ansible, e.g. AWS.pem → AWS)"
  type        = string
  default     = "AWS"
}

variable "ingress_source_cidr" {
  description = "CIDR allowed for monitoring UI and scrape endpoints (3000, 3100, 9090, 9093, 9100, 9115). Use your IP/32 for production, or 0.0.0.0/0 during setup."
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "EC2 size for the dedicated monitoring host. t3.small = 2 GiB RAM (typical for Prometheus + Grafana + Loki stack)."
  type        = string
  default     = "t3.small"
}

variable "root_volume_size_gb" {
  description = "Root disk size (GiB); 20+ recommended if Loki retains local chunks."
  type        = number
  default     = 30
}

variable "root_volume_type" {
  description = "Root EBS volume type (gp3 recommended)."
  type        = string
  default     = "gp3"
}
