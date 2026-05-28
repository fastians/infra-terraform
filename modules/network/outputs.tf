output "vpc_id" {
  description = "VPC ID (created or existing)."
  value       = local.vpc_id
}

output "public_subnet_id" {
  description = "Created public subnet ID."
  value       = aws_subnet.public.id
}
