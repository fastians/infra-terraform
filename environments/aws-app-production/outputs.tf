output "backend_public_ip" {
  description = "Public IPv4 of the production backend EC2 (ansible_host for backend-aws-prod)."
  value       = module.backend.public_ip
}

output "backend_private_ip" {
  description = "Private VPC IP of the production backend EC2."
  value       = module.backend.private_ip
}

output "salome_public_ip" {
  description = "Public IPv4 of the production salome EC2 (ansible_host for salome-aws-prod)."
  value       = module.salome.public_ip
}

output "salome_private_ip" {
  description = "Private VPC IP of the production salome EC2."
  value       = module.salome.private_ip
}

output "geo_public_ip" {
  description = "Public IPv4 of the dedicated GEO EC2 (empty when enable_split_microservices=false)."
  value       = try(module.geo[0].public_ip, null)
}

output "geo_private_ip" {
  description = "Private VPC IP of the dedicated GEO EC2 — use for nginx_geo_upstream and GEO_SERVER_URL."
  value       = try(module.geo[0].private_ip, null)
}

output "llm_public_ip" {
  description = "Public IPv4 of the dedicated LLM EC2 (empty when enable_split_microservices=false)."
  value       = try(module.llm[0].public_ip, null)
}

output "llm_private_ip" {
  description = "Private VPC IP of the dedicated LLM EC2 — use for nginx_llm_upstream and LLM_SERVER_URL."
  value       = try(module.llm[0].private_ip, null)
}

output "backend_instance_id" {
  description = "Backend EC2 instance ID."
  value       = module.backend.instance_id
}

output "salome_instance_id" {
  description = "Salome EC2 instance ID."
  value       = module.salome.instance_id
}

output "geo_instance_id" {
  description = "GEO EC2 instance ID (null when split microservices disabled)."
  value       = try(module.geo[0].instance_id, null)
}

output "llm_instance_id" {
  description = "LLM EC2 instance ID (null when split microservices disabled)."
  value       = try(module.llm[0].instance_id, null)
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
  description = "Shared security group attached to production instances."
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

output "ssh_command_example_geo" {
  description = "Example SSH to GEO host (null when split microservices disabled)."
  value       = var.enable_split_microservices ? "ssh -i ~/.ssh/<your-private-key> ubuntu@${module.geo[0].public_ip}" : null
}

output "ssh_command_example_llm" {
  description = "Example SSH to LLM host (null when split microservices disabled)."
  value       = var.enable_split_microservices ? "ssh -i ~/.ssh/<your-private-key> ubuntu@${module.llm[0].public_ip}" : null
}

output "frontend_aws_region" {
  description = "S3 SPA origin region (Seoul)."
  value       = module.frontend.aws_region
}

output "frontend_bucket_name" {
  description = "S3 bucket for SPA deploy (aws s3 sync dist/)."
  value       = module.frontend.bucket_name
}

output "frontend_cloudfront_distribution_id" {
  description = "CloudFront distribution id for cache invalidation."
  value       = module.frontend.cloudfront_distribution_id
}

output "frontend_site_urls" {
  description = "Public HTTPS URLs for the simulation frontend."
  value       = module.frontend.site_urls
}

output "frontend_cloudfront_domain" {
  description = "Default CloudFront hostname (*.cloudfront.net)."
  value       = module.frontend.cloudfront_domain_name
}

output "frontend_acm_validation_records" {
  description = "ACM cert validation — add as CNAME records in Cloudflare before custom HTTPS works."
  value       = module.frontend.acm_dns_validation_records
}

output "frontend_cloudflare_cname_records" {
  description = "SPA traffic: CNAME in Cloudflare to CloudFront (not an A record to an IP)."
  value       = module.frontend.cloudflare_cname_records
}
