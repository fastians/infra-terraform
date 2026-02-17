variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ssh_public_key" {
  description = "SSH public key content for EC2 key pair"
  type        = string
}

variable "key_name" {
  description = "Name for the EC2 key pair"
  type        = string
  default     = "aws-dev-key"
}

variable "ingress_source_cidr" {
  description = "CIDR allowed for monitoring ingress (TCP 3000, 3100, 9090, 9093). Use your IP/32 for security, or 0.0.0.0/0 to allow all."
  type        = string
  default     = "0.0.0.0/0"
}
