variable "project" {}

variable "firewall_rules" {
  type = map(object({
    protocol = string
    ports    = list(string)
  }))
  default = {
    "web" = {
      protocol = "tcp"
      ports    = ["80", "443"]
    }
    "admin" = {
      protocol = "tcp"
      ports    = ["22"]
    }
  }
}

resource "google_compute_firewall" "dynamic_ingress" {
  project = var.project
  name    = "example-dynamic-firewall"
  network = "default"

  # The "allow" label matches the nested block name in GCP
  dynamic "allow" {
    for_each = var.firewall_rules
    
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = ["0.0.0.0/0"]
}
