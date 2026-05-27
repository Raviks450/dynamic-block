#google_compute_instance — dynamic attached disks

variable "extra_disks" {
  type = list(object({
    source = string
    mode   = string  # READ_WRITE or READ_ONLY
  }))
  default = [
    { source = "projects/my-proj/disks/disk-a", mode = "READ_WRITE" },
    { source = "projects/my-proj/disks/disk-b", mode = "READ_ONLY"  }
  ]
}

resource "google_compute_instance" "vm" {
  name         = "my-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params { image = "debian-cloud/debian-11" }
  }

  network_interface {
    network = "default"
  }

  # Generates one attached_disk block per item in var.extra_disks
  dynamic "attached_disk" {
    for_each = var.extra_disks
    iterator = disk                    # optional; defaults to "attached_disk"

    content {
      source = disk.value.source
      mode   = disk.value.mode
    }
  }
}