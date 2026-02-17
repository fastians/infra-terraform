variable "azure_region" {
  description = "Azure region (e.g. East US)"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "azure-dev-rg"
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
}

variable "ingress_source_cidr" {
  description = "CIDR allowed for monitoring ingress (TCP 3000, 3100, 9090, 9093). Use your IP/32 or 0.0.0.0/0."
  type        = string
  default     = "0.0.0.0/0"
}
