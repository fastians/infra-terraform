variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the aws-app-dev VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the aws-app-dev public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "ssh_public_key" {
  description = "SSH public key content for EC2 key pair"
  type        = string
}

variable "key_name" {
  description = "Name for the EC2 key pair"
  type        = string
  default     = "aws-app-dev-key"
}

variable "ingress_source_cidr" {
  description = "CIDR allowed for monitoring ingress (TCP 3000, 3100, 9090, 9093). Use your IP/32 for security, or 0.0.0.0/0 to allow all."
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "EC2 size for the dev app instance. t3.nano is minimum cost/RAM; use t3.micro or larger if colocating heavier stacks. For dedicated monitoring use environments/aws-monitoring-prod."
  type        = string
  default     = "t3.nano"
}

variable "root_volume_size_gb" {
  description = "Root disk size (GiB) per instance; 8 is a practical minimum for Ubuntu 22.04."
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Root EBS volume type (gp3 recommended)."
  type        = string
  default     = "gp3"
}
