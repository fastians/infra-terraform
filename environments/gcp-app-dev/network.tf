resource "google_compute_network" "main" {
  name                    = "gcp-app-dev-vpc"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "public" {
  name          = "gcp-app-dev-public"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.gcp_region
  network       = google_compute_network.main.id
}

resource "google_compute_router" "main" {
  name    = "gcp-app-dev-router"
  region  = var.gcp_region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "main" {
  name                               = "gcp-app-dev-nat"
  router                             = google_compute_router.main.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
