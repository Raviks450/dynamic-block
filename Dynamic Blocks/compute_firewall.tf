#google_compute_firewall — dynamic allow/deny rules
#Firewall rules are the richest example — you can have multiple allow or deny blocks, each with different protocols and port lists:

variable "allow_rules" {
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
  default = [
    { protocol = "tcp", ports = ["80", "443"] },
    { protocol = "tcp", ports = ["8080", "8443"] },
    { protocol = "icmp", ports = [] },
  ]
}

variable "deny_rules" {
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
  default = [
    { protocol = "tcp", ports = ["22"] },
  ]
}

resource "google_compute_firewall" "rules" {
  name    = "my-firewall"
  network = google_compute_network.vpc["prod"].id

  source_ranges = ["0.0.0.0/0"]

  # Multiple allow blocks generated dynamically
  dynamic "allow" {
    for_each = var.allow_rules
    iterator = rule

    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }

  # Multiple deny blocks generated dynamically
  dynamic "deny" {
    for_each = var.deny_rules
    iterator = rule

    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }
}

/*Key tips
Use for_each with a map (not a list) when order matters — maps give stable keys, preventing unnecessary resource churn if you reorder items.
Skip a dynamic block entirely with an empty collection — for_each = [] or for_each = {} produces zero blocks, which is cleaner than count = 0 tricks.
iterator.key gives the map key (or list index); iterator.value gives the element value.
Nested dynamics are allowed — you can put a dynamic inside a content {} block, though it's rarely needed and can hurt readability.*/