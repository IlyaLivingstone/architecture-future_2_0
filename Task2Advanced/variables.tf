variable "environment" {
  description = "Окружение"
  type        = string

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment: dev, stage или prod"
  }
}

variable "project" {
  description = "Имя проекта"
  type        = string
  default     = "future20"
}

variable "cloud_id" {
  description = "ID облака"
  type        = string
}

variable "folder_id" {
  description = "ID каталога"
  type        = string
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "ssh_key" {
  description = "Публичный SSH-ключ"
  type        = string
}

variable "cores" {
  description = "Ядра vCPU"
  type        = number
  default     = 2
}

variable "ram_gb" {
  description = "Оперативная память, ГБ"
  type        = number
  default     = 4
}

variable "boot_disk_gb" {
  description = "Загрузочный диск, ГБ"
  type        = number
  default     = 20
}

variable "data_disk_gb" {
  description = "Дополнительный диск, ГБ"
  type        = number
  default     = 20
}
