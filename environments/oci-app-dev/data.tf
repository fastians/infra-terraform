data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

data "oci_core_subnet" "subnet" {
  subnet_id = var.subnet_ocid
}

data "oci_core_vcn" "vcn" {
  vcn_id = data.oci_core_subnet.subnet.vcn_id
}

data "oci_core_images" "ubuntu" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}
