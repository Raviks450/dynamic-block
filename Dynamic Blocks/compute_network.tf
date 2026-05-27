#google_compute_network — dynamic routing config
#google_compute_network has a single optional timeouts block, 
#but a more useful pattern here is pairing it with google_compute_subnetwork using for_each:

# Networks themselves rarely need dynamic blocks,
# but you can dynamically create multiple networks:

variable "networks" {
  type = map(object({
    auto_create_subnetworks = bool
    routing_mode            = string
  }))
  default = {
    prod = { auto_create_subnetworks = false, routing_mode = "REGIONAL" }
    dev  = { auto_create_subnetworks = true,  routing_mode = "GLOBAL"   }
  }
}

resource "google_compute_network" "vpc" {
  for_each = var.networks          # resource-level for_each, not dynamic

  name                    = each.key
  auto_create_subnetworks = each.value.auto_create_subnetworks
  routing_mode            = each.value.routing_mode
}