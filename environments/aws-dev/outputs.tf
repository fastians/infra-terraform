output "public_ip" {
  value       = aws_instance.vm.public_ip
  description = "dev-monitor public IP"
}

output "monitor_public_ip" {
  value       = aws_instance.vm.public_ip
  description = "dev-monitor public IP (alias)"
}

output "monitoring_server_public_ip" {
  value       = aws_instance.monitoring_server.public_ip
  description = "monitoring-server public IP"
}
