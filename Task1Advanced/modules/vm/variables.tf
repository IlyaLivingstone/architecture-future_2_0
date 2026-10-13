variable "name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "zone" {
  description = "Зона доступности"
  type        = string
}

variable "cores" {
  description = "Количество ядер vCPU"
  type        = number

  validation {
    condition     = var.cores >= 1 && floor(var.cores) == var.cores
    error_message = "cores — целое число не меньше 1"
  }
}

variable "ram_gb" {
  description = "Объём оперативной памяти, ГБ"
  type        = number

  validation {
    condition     = var.ram_gb >= 1
    error_message = "ram_gb должно быть не меньше 1"
  }
}

variable "image_family" {
  description = "Семейство образов для загрузочного диска"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "boot_disk_gb" {
  description = "Размер загрузочного диска, ГБ"
  type        = number
  default     = 20

  validation {
    condition     = var.boot_disk_gb >= 10
    error_message = "boot_disk_gb должно быть не меньше 10"
  }
}

variable "data_disk_name" {
  description = "Имя дополнительного диска"
  type        = string
}

variable "data_disk_gb" {
  description = "Размер дополнительного диска, ГБ"
  type        = number

  validation {
    condition     = var.data_disk_gb >= 10
    error_message = "data_disk_gb должно быть не меньше 10"
  }
}

variable "subnet_id" {
  description = "Subnet ID, к которому подключается сетевой интерфейс"
  type        = string
}

variable "ssh_user" {
  description = "Пользователь Linux для SSH-доступа"
  type        = string
  default     = "ubuntu"
}

variable "ssh_key" {
  description = "Публичный SSH-ключ в формате OpenSSH"
  type        = string

  validation {
    condition     = length(trimspace(var.ssh_key)) > 0
    error_message = "ssh_key не может быть пустым"
  }
}

variable "public_ip" {
  description = "Выдавать виртуальной машине публичный IP-адрес"
  type        = bool
  default     = true
}
