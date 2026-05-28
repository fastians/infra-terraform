variable "name_prefix" {
  description = "Prefix used to build network resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC when creating a new VPC. Ignored if existing_vpc_id is set."
  type        = string
  default     = ""
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the public subnet."
  type        = string
}

variable "existing_vpc_id" {
  description = "When set, attach the public subnet to this VPC instead of creating a new VPC (saves VPC quota)."
  type        = string
  default     = ""
}
