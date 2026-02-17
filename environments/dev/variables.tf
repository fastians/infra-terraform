variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}

variable "subnet_ocid" {
  description = "Existing Subnet OCID"
  type        = string
}

variable "ingress_source_cidr" {
  description = "CIDR allowed for monitoring ingress (TCP 3000, 3100, 9090, 9093). Use your IP/32 for security, or 0.0.0.0/0 to allow all."
  type        = string
  default     = "0.0.0.0/0"
}
