output "public_ip" {
  value = oci_core_instance.vm.public_ip
}
output "monitor_public_ip" {
  value = oci_core_instance.vm.public_ip
}

output "monitoring_server_public_ip" {
  value = oci_core_instance.monitoring_server.public_ip
}
