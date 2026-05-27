#google_compute_subnetwork — dynamic secondary IP ranges
#This is one of the most common real-world uses of dynamic on GCP — adding multiple secondary ranges (used by GKE for Pods and Services):

variable "secondary_ranges" {
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
  default = [
    { range_name = "pods",     ip_cidr_range = "10.1.0.0/16" },
    { range_name = "services", ip_cidr_range = "10.2.0.0/20" },
  ]
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc["prod"].id

  # Generates one secondary_ip_range block per item
  dynamic "secondary_ip_range" {
    for_each = var.secondary_ranges

    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}