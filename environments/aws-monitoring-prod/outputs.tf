output "public_ip" {
  description = "Public IPv4 for the monitoring host — paste into Ansible inventories/prod/hosts.ini as ansible_host for monitoring-aws"
  value       = module.compute.public_ip
}

output "monitoring_public_ip" {
  description = "Alias for public_ip"
  value       = module.compute.public_ip
}

output "ssh_user" {
  description = "SSH user for Ubuntu 22.04"
  value       = "ubuntu"
}

output "ssh_command_example" {
  description = "Example SSH (private key must match the key_name key pair in EC2)"
  value       = "ssh -i /path/to/private-key.pem ubuntu@${module.compute.public_ip}"
}

output "instance_id" {
  description = "EC2 instance id"
  value       = module.compute.instance_id
}
