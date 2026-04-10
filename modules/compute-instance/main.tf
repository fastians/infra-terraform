variable "name" {
  description = "Name tag for the instance."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will run."
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs to attach."
  type        = list(string)
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "root_volume_size_gb" {
  description = "Root EBS volume size in GiB."
  type        = number
}

variable "metadata_http_tokens" {
  description = "IMDSv2 token requirement for metadata service."
  type        = string
  default     = "optional"
}

variable "metadata_hop_limit" {
  description = "Hop limit for IMDS responses."
  type        = number
  default     = 1
}

variable "extra_tags" {
  description = "Additional tags to merge into instance tags."
  type        = map(string)
  default     = {}
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size_gb
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_tokens                 = var.metadata_http_tokens
    http_endpoint               = "enabled"
    http_put_response_hop_limit = var.metadata_hop_limit
  }

  tags = merge(
    {
      Name = var.name
    },
    var.extra_tags
  )
}
