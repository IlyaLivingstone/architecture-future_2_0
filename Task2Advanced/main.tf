locals {
  vm_name   = "${var.project}-vm-${var.environment}"
  disk_name = "${var.project}-disk-${var.environment}"
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

# инфраструктура описана в модуле задания 1, здесь только параметры окружения
module "vm" {
  source = "../Task1Advanced/modules/vm"

  name           = local.vm_name
  zone           = var.zone
  cores          = var.cores
  ram_gb         = var.ram_gb
  boot_disk_gb   = var.boot_disk_gb
  data_disk_name = local.disk_name
  data_disk_gb   = var.data_disk_gb
  subnet_id      = var.subnet_id
  ssh_key        = var.ssh_key
}
