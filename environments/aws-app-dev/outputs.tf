output "public_ip" {
  description = "Public IPv4 for SSH, rsync, git deploy, etc."
  value       = module.compute.public_ip
}

output "ssh_user" {
  description = "SSH user for the Ubuntu 22.04 image"
  value       = "ubuntu"
}

output "ssh_command_example" {
  description = "Example SSH (replace key path; key must match the public key in terraform.tfvars)"
  value       = "ssh -i ~/.ssh/<your-private-key> ubuntu@${module.compute.public_ip}"
}
