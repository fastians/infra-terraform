variable "aws_region" {
  description = "AWS region for deployment."
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Project name used in resource names and tags."
  type        = string
  default     = "mek-lab"
}

variable "environment" {
  description = "Environment label used in names and tags."
  type        = string
  default     = "app-prod"
}

variable "vpc_cidr" {
  description = "CIDR block for the aws-app-prod VPC. Distinct from aws-app-dev (10.0/16) and aws-monitoring-prod (10.1/16)."
  type        = string
  default     = "10.2.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the aws-app-prod public subnet."
  type        = string
  default     = "10.2.1.0/24"
}

variable "ssh_public_key" {
  description = "SSH public key content for EC2 key pair."
  type        = string
}

variable "key_name" {
  description = "Name for the EC2 key pair."
  type        = string
  default     = "mek-lab-app-prod-key"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to access SSH."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed to access HTTP/HTTPS."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_app_cidrs" {
  description = "CIDR blocks allowed to access application ports 8000-8002."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_monitoring_cidrs" {
  description = "CIDR blocks allowed to access monitoring ports (3000, 3100, 9090, 9093, 9100, 9115)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "backend_instance_type" {
  description = "EC2 instance type for the backend host (3 FastAPI apps)."
  type        = string
  default     = "t3.large"
}

variable "salome_instance_type" {
  description = "EC2 instance type for the Salome host."
  type        = string
  default     = "t3.large"
}

variable "backend_root_volume_size_gb" {
  description = "Backend root EBS disk size (GiB). Mirrors GCP backend (~48 GB used)."
  type        = number
  default     = 50

  validation {
    condition     = var.backend_root_volume_size_gb >= 50 && var.backend_root_volume_size_gb <= 200
    error_message = "backend_root_volume_size_gb must be between 50 and 200."
  }
}

variable "salome_root_volume_size_gb" {
  description = "Salome root EBS disk size (GiB). Mirrors GCP salome (~38 GB used)."
  type        = number
  default     = 50

  validation {
    condition     = var.salome_root_volume_size_gb >= 50 && var.salome_root_volume_size_gb <= 200
    error_message = "salome_root_volume_size_gb must be between 50 and 200."
  }
}

variable "root_volume_type" {
  description = "Root EBS volume type (gp3 recommended)."
  type        = string
  default     = "gp3"
}

variable "tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default     = {}
}
