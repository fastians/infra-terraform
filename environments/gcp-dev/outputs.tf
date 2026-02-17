output "public_ip" {
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
  description = "dev-monitor public IP"
}

output "monitor_public_ip" {
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
  description = "dev-monitor public IP (alias)"
}

output "monitoring_server_public_ip" {
  value       = google_compute_instance.monitoring_server.network_interface[0].access_config[0].nat_ip
  description = "monitoring-server public IP"
}
