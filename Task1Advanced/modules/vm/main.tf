terraform {
  required_version = ">= 1.5"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

data "yandex_compute_image" "os" {
  family = var.image_family
}

resource "yandex_compute_instance" "vm" {
  name     = var.name
  hostname = var.name
  zone     = var.zone

  resources {
    cores  = var.cores
    memory = var.ram_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.id
      size     = var.boot_disk_gb
      type     = "network-ssd"
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.data.id
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.public_ip
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${trimspace(var.ssh_key)}"
  }
}

resource "yandex_compute_disk" "data" {
  name = var.data_disk_name
  zone = var.zone
  size = var.data_disk_gb
  type = "network-ssd"
}
