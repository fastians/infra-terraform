# SSH from anywhere
resource "google_compute_firewall" "ssh" {
  name    = "gcp-dev-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  priority      = 1000
}

# Grafana, Loki, Prometheus, Alertmanager
resource "google_compute_firewall" "monitoring" {
  name    = "gcp-dev-monitoring"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["3000", "3100", "9090", "9093"]
  }
  source_ranges = [var.ingress_source_cidr]
  direction     = "INGRESS"
  priority      = 1000
}
