output "public_ip" {
  description = "Public IPv4 for SSH, rsync, git deploy, etc."
  value       = module.compute.public_ip
}

output "vpc_id" {
  description = "VPC ID used by the app host."
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID where the instance is deployed."
  value       = module.network.public_subnet_id
}

output "security_group_id" {
  description = "Security group attached to the instance."
  value       = module.security.security_group_id
}

output "ssh_user" {
  description = "SSH user for the Ubuntu image."
  value       = "ubuntu"
}

output "ssh_command_example" {
  description = "Example SSH (replace key path; key must match terraform.tfvars)."
  value       = "ssh -i ~/.ssh/<your-private-key> ubuntu@${module.compute.public_ip}"
}

output "instance_id" {
  description = "EC2 instance ID."
  value       = module.compute.instance_id
}
