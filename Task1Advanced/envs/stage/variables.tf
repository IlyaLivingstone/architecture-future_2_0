variable "yc_token" {
  description = "OAuth-токен Yandex Cloud"
  type        = string
  default     = null
  sensitive   = true
}

variable "cloud_id" {
  description = "ID облака"
  type        = string

  validation {
    condition     = can(regex("^b1g[a-z0-9]{17}$", var.cloud_id))
    error_message = "Подставьте cloud_id своего облака вместо плейсхолдера"
  }
}

variable "folder_id" {
  description = "ID каталога"
  type        = string

  validation {
    condition     = can(regex("^b1g[a-z0-9]{17}$", var.folder_id))
    error_message = "Подставьте folder_id своего каталога вместо плейсхолдера"
  }
}

variable "zone" {
  description = "Зона доступности"
  type        = string
}

variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "cores" {
  description = "Ядра vCPU"
  type        = number
}

variable "ram_gb" {
  description = "Оперативная память, ГБ"
  type        = number
}

variable "boot_disk_gb" {
  description = "Загрузочный диск, ГБ"
  type        = number
}

variable "data_disk_name" {
  description = "Имя дополнительного диска"
  type        = string
}

variable "data_disk_gb" {
  description = "Дополнительный диск, ГБ"
  type        = number
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string

  validation {
    condition     = can(regex("^e9b[a-z0-9]{17}$", var.subnet_id))
    error_message = "Подставьте subnet_id своей подсети вместо плейсхолдера"
  }
}

variable "ssh_key" {
  description = "Публичный SSH-ключ"
  type        = string
}
