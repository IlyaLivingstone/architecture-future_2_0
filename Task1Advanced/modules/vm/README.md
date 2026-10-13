# Модуль vm

Создаёт в Yandex Cloud виртуальную машину с дополнительным диском и доступом
по SSH. Сеть не создаёт — подключается к подсети, переданной в `subnet_id`.
Диски создаются типа `network-ssd`.

## Переменные

| Имя | Тип | По умолчанию | Описание |
|---|---|---|---|
| `name` | string | — | имя ВМ, оно же hostname |
| `zone` | string | — | зона доступности |
| `cores` | number | — | ядра vCPU |
| `ram_gb` | number | — | оперативная память, ГБ |
| `image_family` | string | `ubuntu-2204-lts` | семейство образов |
| `boot_disk_gb` | number | `20` | размер загрузочного диска, ГБ |
| `data_disk_name` | string | — | имя дополнительного диска |
| `data_disk_gb` | number | — | размер дополнительного диска, ГБ |
| `subnet_id` | string | — | подсеть для сетевого интерфейса |
| `ssh_user` | string | `ubuntu` | пользователь для SSH |
| `ssh_key` | string | — | публичный SSH-ключ |
| `public_ip` | bool | `true` | выдавать публичный IP-адрес |

Размеры и количество ядер проверяются на уровне переменных, пустой `ssh_key`
не пропускается.

## Выходы

| Имя | Описание |
|---|---|
| `instance_id` | идентификатор созданной ВМ |
| `instance_name` | имя ВМ |
| `private_ip` | адрес во внутренней сети |
| `public_ip` | публичный адрес, `null` если `public_ip = false` |
| `data_disk_id` | идентификатор диска с данными |

## Пример вызова

```hcl
module "vm" {
  source = "../../modules/vm"

  name           = "future20-vm-dev"
  zone           = "ru-central1-a"
  cores          = 2
  ram_gb         = 4
  boot_disk_gb   = 15
  data_disk_name = "future20-disk-dev"
  data_disk_gb   = 15
  subnet_id      = "e9b..."
  ssh_key        = file("~/.ssh/id_ed25519.pub")
}
```
