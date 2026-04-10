resource "oci_core_default_security_list" "default_sl" {
  manage_default_resource_id = data.oci_core_vcn.vcn.default_security_list_id
  display_name               = "default-security-list-managed"

  # SSH
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Grafana (3000), Loki (3100), Prometheus (9090), Alertmanager (9093)
  ingress_security_rules {
    protocol    = "6"
    source      = var.ingress_source_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 3000
      max = 3000
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.ingress_source_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 3100
      max = 3100
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.ingress_source_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 9090
      max = 9090
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.ingress_source_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 9093
      max = 9093
    }
  }

  egress_security_rules {
    protocol         = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    stateless        = false
  }
}
