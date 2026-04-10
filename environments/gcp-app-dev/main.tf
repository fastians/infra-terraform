resource "google_compute_instance" "dev_app" {
  name         = "dev-monitor"
  machine_type = "e2-micro"
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = 10
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public.self_link
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  tags = ["gcp-app-dev-monitoring"]
}

resource "google_compute_instance" "monitoring_server" {
  name         = "monitoring-server"
  machine_type = "e2-micro"
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = 10
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public.self_link
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  tags = ["gcp-app-dev-monitoring"]
}
