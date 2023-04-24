data "google_service_account" "default" {
  account_id = var.service_account_id
}

resource "google_compute_instance" "default" {
  name         = "myfirst-instance-from-tf"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["web", "http-server"]

  boot_disk {
    initialize_params {
      image = var.image
      labels = {
        my_label = "value"
      }
    }
  }

   network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

     metadata_startup_script = "${file("/home/bindu/terraform-GCP/startup")}"
}
resource "google_compute_firewall" "default" {
 name    = "web-firewall"
 network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "1000-4000"]
  }
 source_ranges = ["0.0.0.0/0"]
 target_tags = ["http-server"]
}
