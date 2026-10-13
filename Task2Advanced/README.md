# Задание 2

Состояние Terraform хранится в Yandex Object Storage, развёртывание выполняет
пайплайн GitHub Actions. Пайплайн создаёт виртуальную машину через модуль
из задания 1.

## Файлы

| Файл | Что внутри |
|---|---|
| `backend.tf` | `terraform` (версия, провайдер `yandex`) и `backend "s3" {}` без параметров |
| `main.tf` | `provider "yandex"` и вызов `module "vm"` из задания 1 |
| `variables.tf`, `outputs.tf` | окружение, идентификаторы облака, размеры ВМ, выходы |
| `backend.hcl.example` | пример параметров Object Storage |
| `terraform.tfvars.example` | пример значений переменных |

Пайплайн лежит в корне — `.github/workflows/terraform.yml` (GitHub Actions
читает workflow только из `.github/workflows`).

## Что нужно подготовить в облаке

1. Сервисный аккаунт с правами на создание ВМ и дисков (роль `editor` или
   `compute.editor` + `vpc.user`) и на бакет (`storage.editor`).
2. Для него два ключа:
   - авторизованный ключ (JSON) — им провайдер `yandex` создаёт ВМ;
   - статический ключ доступа (`key_id` + `secret`) — им Terraform пишет state
     в Object Storage.
3. Бакет `future20-terraform-state` (или свой — тогда поменять `bucket`).
4. `cloud_id`, `folder_id`, `subnet_id`, публичный SSH-ключ.

## Локальный запуск

```bash
cd Task2Advanced

export YC_SERVICE_ACCOUNT_KEY_FILE="/путь/к/key.json"   # или YC_TOKEN
export AWS_ACCESS_KEY_ID="<key_id статического ключа>"
export AWS_SECRET_ACCESS_KEY="<secret статического ключа>"

cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars   # подставить свои значения

terraform init  -backend-config=backend.hcl
terraform plan  -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
terraform output
```

Провайдер авторизуется так: если задан `YC_SERVICE_ACCOUNT_KEY_FILE` — берёт
ключ из файла, иначе пробует `YC_TOKEN`.

## Проверка, что состояние удалённое

```bash
ls terraform.tfstate     # файла нет
terraform state list     # читает из Object Storage: module.vm...
```

Состояние лежит в бакете по пути `future20/task2/<env>/terraform.tfstate`.
`terraform.tfstate`, `terraform.tfvars` и `backend.hcl` в репозиторий
не попадают (см. `.gitignore`).

## Параметры backend

| Параметр | Значение | Зачем |
|---|---|---|
| `bucket` | `future20-terraform-state` | бакет под state |
| `key` | `future20/task2/<env>/terraform.tfstate` | своё состояние на каждое окружение |
| `region` | `ru-central1` | регион |
| `endpoint` | `https://storage.yandexcloud.net` | S3-совместимый API Object Storage |
| `force_path_style` | `true` | path-style адресация |
| `skip_credentials_validation` и остальные `skip_*` | `true` | отключают проверки, которых нет вне AWS |
| `use_lockfile` | `true` | блокировка состояния файлом `.tflock` рядом со state |

## Пайплайн

Запуск вручную: `workflow_dispatch` с параметрами `environment` (dev, stage,
prod) и `apply` (true/false).

Job `plan`: checkout без сохранения токена, установка Terraform 1.16.5,
запись ключа сервисного аккаунта в файл, `terraform fmt -check -recursive`,
`init` с `-backend-config`, `validate`, `plan -out=tfplan`, выгрузка плана
в artifact.

Job `apply`: запускается после успешного `plan` и только при `apply = true`,
заново делает `init`, забирает план из artifact и выполняет
`terraform apply tfplan` — применяется ровно проверенный план.

Дополнительно: `permissions: contents: read`, `concurrency` на окружение
(два прогона не подерутся за состояние), `TF_INPUT=false`,
`-lock-timeout=5m`, `timeout-minutes: 20`. На окружении `prod` в GitHub
включается правило Required reviewers — без подтверждения человека
`apply` не стартует.

## Секреты и переменные окружений

На каждое окружение (`dev`, `stage`, `prod`) в GitHub заводится Environment,
в него кладутся секреты и переменные:

| Тип | Имя | Что это |
|---|---|---|
| secret | `YC_SA_KEY` | авторизованный ключ сервисного аккаунта (JSON) |
| secret | `TF_STATE_ACCESS_KEY` | `key_id` статического ключа для Object Storage |
| secret | `TF_STATE_SECRET_KEY` | `secret` статического ключа для Object Storage |
| variable | `YC_CLOUD_ID` | идентификатор облака |
| variable | `YC_FOLDER_ID` | идентификатор каталога |
| variable | `YC_SUBNET_ID` | подсеть |
| variable | `SSH_PUBLIC_KEY` | публичный SSH-ключ |

Так у каждого окружения свои значения, а в репозитории нет ни одного секрета.

## Замечания

`use_lockfile` требует Terraform 1.10+ и поддержки conditional writes
в Object Storage — Terraform из пайплайна (1.16.5) это умеет.
