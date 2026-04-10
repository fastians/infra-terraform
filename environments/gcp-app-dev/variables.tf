variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "ssh_public_key" {
  description = "SSH public key content (for metadata)"
  type        = string
}

variable "ingress_source_cidr" {
  description = "CIDR allowed for monitoring ingress (TCP 3000, 3100, 9090, 9093). Use your IP/32 or 0.0.0.0/0."
  type        = string
  default     = "0.0.0.0/0"
}
