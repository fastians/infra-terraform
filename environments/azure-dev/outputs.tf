output "public_ip" {
  value       = azurerm_public_ip.vm.ip_address
  description = "dev-monitor public IP"
}

output "monitor_public_ip" {
  value       = azurerm_public_ip.vm.ip_address
  description = "dev-monitor public IP (alias)"
}

output "monitoring_server_public_ip" {
  value       = azurerm_public_ip.monitoring_server.ip_address
  description = "monitoring-server public IP"
}
