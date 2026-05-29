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

variable "enable_split_microservices" {
  description = "When true, create dedicated GEO and LLM EC2 instances (4-server production model)."
  type        = bool
  default     = false
}

variable "backend_instance_type" {
  description = "EC2 instance type for the production backend/API host (Nginx + backendserver). m7i.2xlarge = 8 vCPU, 32 GiB."
  type        = string
  default     = "m7i.2xlarge"
}

variable "geo_instance_type" {
  description = "EC2 instance type for the dedicated GEO host (FreeCAD/pythonocc). c7i.4xlarge = 16 vCPU, 32 GiB."
  type        = string
  default     = "c7i.4xlarge"
}

variable "llm_instance_type" {
  description = "EC2 instance type for the dedicated LLM/RAG host. m7i.xlarge = 4 vCPU, 16 GiB."
  type        = string
  default     = "m7i.xlarge"
}

variable "salome_instance_type" {
  description = "EC2 instance type for the production Salome host (FEM + Singularity). r7i.8xlarge = 32 vCPU, 256 GiB."
  type        = string
  default     = "r7i.8xlarge"
}

variable "backend_root_volume_size_gb" {
  description = "Backend root EBS disk size (GiB)."
  type        = number
  default     = 200

  validation {
    condition     = var.backend_root_volume_size_gb >= 50 && var.backend_root_volume_size_gb <= 500
    error_message = "backend_root_volume_size_gb must be between 50 and 500."
  }
}

variable "geo_root_volume_size_gb" {
  description = "GEO root EBS disk size (GiB)."
  type        = number
  default     = 500

  validation {
    condition     = var.geo_root_volume_size_gb >= 100 && var.geo_root_volume_size_gb <= 1000
    error_message = "geo_root_volume_size_gb must be between 100 and 1000."
  }
}

variable "llm_root_volume_size_gb" {
  description = "LLM root EBS disk size (GiB)."
  type        = number
  default     = 200

  validation {
    condition     = var.llm_root_volume_size_gb >= 50 && var.llm_root_volume_size_gb <= 500
    error_message = "llm_root_volume_size_gb must be between 50 and 500."
  }
}

variable "salome_root_volume_size_gb" {
  description = "Salome root EBS disk size (GiB)."
  type        = number
  default     = 1000

  validation {
    condition     = var.salome_root_volume_size_gb >= 100 && var.salome_root_volume_size_gb <= 2000
    error_message = "salome_root_volume_size_gb must be between 100 and 2000."
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
