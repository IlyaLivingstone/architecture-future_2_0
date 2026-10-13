output "instance_id" {
  description = "Идентификатор созданной ВМ"
  value       = yandex_compute_instance.vm.id
}

output "instance_name" {
  description = "Имя ВМ"
  value       = yandex_compute_instance.vm.name
}

output "private_ip" {
  description = "Адрес во внутренней сети"
  value       = yandex_compute_instance.vm.network_interface.0.ip_address
}

output "public_ip" {
  description = "Публичный адрес, null если public_ip = false"
  value       = try(yandex_compute_instance.vm.network_interface.0.nat_ip_address, null)
}

output "data_disk_id" {
  description = "Идентификатор диска с данными"
  value       = yandex_compute_disk.data.id
}
