terraform {
  required_version = ">= 1.5"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
  zone      = var.zone
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  token     = var.yc_token
}

# окружение своих ресурсов не описывает — только передаёт параметры в модуль
module "vm" {
  source = "../../modules/vm"

  name           = var.vm_name
  zone           = var.zone
  cores          = var.cores
  ram_gb         = var.ram_gb
  boot_disk_gb   = var.boot_disk_gb
  data_disk_name = var.data_disk_name
  data_disk_gb   = var.data_disk_gb
  subnet_id      = var.subnet_id
  ssh_key        = var.ssh_key
}
