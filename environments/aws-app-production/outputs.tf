output "backend_public_ip" {
  description = "Public IPv4 of the production backend EC2 (ansible_host for backend-aws-prod)."
  value       = module.backend.public_ip
}

output "salome_public_ip" {
  description = "Public IPv4 of the production salome EC2 (ansible_host for salome-aws-prod)."
  value       = module.salome.public_ip
}

output "backend_instance_id" {
  description = "Backend EC2 instance ID."
  value       = module.backend.instance_id
}

output "salome_instance_id" {
  description = "Salome EC2 instance ID."
  value       = module.salome.instance_id
}

output "vpc_id" {
  description = "VPC ID for the aws-app-production environment."
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID where instances are deployed."
  value       = module.network.public_subnet_id
}

output "security_group_id" {
  description = "Shared security group attached to both instances."
  value       = module.security.security_group_id
}

output "ssh_user" {
  description = "SSH user for the Ubuntu image."
  value       = "ubuntu"
}

output "ssh_command_example_backend" {
  description = "Example SSH to backend (replace key path; key must match terraform.tfvars)."
  value       = "ssh -i ~/.ssh/<your-private-key> ubuntu@${module.backend.public_ip}"
}

output "ssh_command_example_salome" {
  description = "Example SSH to salome (replace key path; key must match terraform.tfvars)."
  value       = "ssh -i ~/.ssh/<your-private-key> ubuntu@${module.salome.public_ip}"
}
