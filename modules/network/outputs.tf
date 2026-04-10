output "vpc_id" {
  description = "Created VPC ID."
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "Created public subnet ID."
  value       = aws_subnet.public.id
}
