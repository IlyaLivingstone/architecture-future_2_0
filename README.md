# architecture-future_2_0

Проектная работа 11 спринта. Кейс «Будущее 2.0»: медицинская компания с финтехом
и ИИ-сервисами, которой нужно уйти от DWH на SQL Server 2008, PowerBuilder и шины
Apache Camel к событийной платформе и витрине самообслуживания.

## Задания

| Папка | Что сдаётся |
|---|---|
| `Task1Advanced` | модуль Terraform `vm` и три окружения со своими `.tfvars` |
| `Task2Advanced` | состояние Terraform в S3-совместимом хранилище и пайплайн GitHub Actions |
| `Task3Advanced` | C4, карта рисков и план управления рисками |
| `Task4Advanced` | bounded contexts, event storming, агрегаты, события, обоснование |
| `Task5Advanced` | технический радар, TCO на три года, роадмап Data Mesh |

## Запуск Terraform-части

```bash
cd Task1Advanced
export TF_VAR_yc_token="<OAuth-токен>"
terraform -chdir=envs/dev init
terraform -chdir=envs/dev apply -var-file=dev.tfvars
```

```bash
cd Task2Advanced
export YC_SERVICE_ACCOUNT_KEY_FILE="/путь/к/key.json"   # или YC_TOKEN
export AWS_ACCESS_KEY_ID="<key_id статического ключа>"
export AWS_SECRET_ACCESS_KEY="<secret статического ключа>"
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
terraform apply
```

Подробности по каждому заданию — в README внутри его папки.
