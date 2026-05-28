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
  default     = "app-production"
}

variable "vpc_cidr" {
  description = "CIDR for a new VPC. Ignored when existing_vpc_id is set (account VPC quota)."
  type        = string
  default     = "10.3.0.0/16"
}

variable "existing_vpc_id" {
  description = "Reuse staging VPC instead of creating a new one (required when VPC limit is reached)."
  type        = string
  default     = ""
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR inside the VPC (must not overlap other subnets)."
  type        = string
  default     = "10.2.2.0/24"
}

variable "ssh_public_key" {
  description = "SSH public key content for EC2 key pair."
  type        = string
}

variable "key_name" {
  description = "Name for the EC2 key pair."
  type        = string
  default     = "mek-lab-app-production-key"
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
  description = "EC2 instance type for the production backend host (GEO runs here). m6i.2xlarge = 8 vCPU, 32 GiB, non-burstable."
  type        = string
  default     = "m6i.2xlarge"
}

variable "salome_instance_type" {
  description = "EC2 instance type for the production Salome host (FEM + Singularity). m6i.2xlarge = 8 vCPU, 32 GiB."
  type        = string
  default     = "m6i.2xlarge"
}

variable "backend_root_volume_size_gb" {
  description = "Backend root EBS disk size (GiB)."
  type        = number
  default     = 80

  validation {
    condition     = var.backend_root_volume_size_gb >= 50 && var.backend_root_volume_size_gb <= 200
    error_message = "backend_root_volume_size_gb must be between 50 and 200."
  }
}

variable "salome_root_volume_size_gb" {
  description = "Salome root EBS disk size (GiB)."
  type        = number
  default     = 100

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
