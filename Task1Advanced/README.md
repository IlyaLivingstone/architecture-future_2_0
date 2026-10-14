# Задание 1

Модуль `modules/vm` создаёт виртуальную машину с дополнительным диском.
Окружения `envs/dev`, `envs/stage`, `envs/prod` вызывают один и тот же модуль
и отличаются только значениями в своих `.tfvars`.

```
Task1Advanced/
├── modules/vm/
│   ├── main.tf        ВМ, диск, сетевой интерфейс
│   ├── variables.tf   параметры модуля
│   ├── outputs.tf     id ВМ, IP-адреса, id диска
│   └── README.md      описание модуля
└── envs/
    ├── dev/           main.tf, variables.tf, outputs.tf, dev.tfvars
    ├── stage/         то же + stage.tfvars
    └── prod/          то же + prod.tfvars
```

## Чем отличаются окружения

|                | dev | stage | prod |
|----------------|-----|-------|------|
| зона           | ru-central1-a | ru-central1-b | ru-central1-a |
| ядра vCPU      | 2 | 4 | 8 |
| RAM, ГБ        | 4 | 8 | 16 |
| загрузочный диск, ГБ | 15 | 25 | 40 |
| дополнительный диск, ГБ | 15 | 40 | 80 |

## Запуск

Токен в репозитории не хранится, он передаётся переменной окружения:

```bash
export TF_VAR_yc_token="<OAuth- или IAM-токен>"
```

В `<env>.tfvars` вместо `replace-with-...` подставьте свои `cloud_id`,
`folder_id` и `subnet_id`, а также свой публичный SSH-ключ. У этих переменных
есть проверка формата, поэтому незаменённый плейсхолдер остановит `plan`
с подсказкой.

```bash
cd Task1Advanced

terraform -chdir=envs/dev init
terraform -chdir=envs/dev plan  -var-file=dev.tfvars
terraform -chdir=envs/dev apply -var-file=dev.tfvars

terraform -chdir=envs/stage init
terraform -chdir=envs/stage apply -var-file=stage.tfvars

terraform -chdir=envs/prod init
terraform -chdir=envs/prod apply -var-file=prod.tfvars
```

Посмотреть, что создалось:

```bash
terraform -chdir=envs/dev output
```

Удалить окружение:

```bash
terraform -chdir=envs/dev destroy -var-file=dev.tfvars
```

Дополнительный диск создаётся без `auto_delete`, поэтому переживает
пересоздание ВМ; `destroy` удаляет его вместе с остальными ресурсами.

## Проверка без облачного аккаунта

`init` и `validate` не обращаются к API, для них аккаунт не нужен:

```bash
terraform -chdir=envs/dev init -backend=false
terraform -chdir=envs/dev validate
```

Если реестр HashiCorp не открывается из вашего региона, провайдер можно
поставить из GitHub-релиза в локальное зеркало:

```bash
V=0.238.0
mkdir -p .terraform-mirror/registry.terraform.io/yandex-cloud/yandex
curl -sSLo ".terraform-mirror/registry.terraform.io/yandex-cloud/yandex/terraform-provider-yandex_${V}_darwin_amd64.zip" \
  "https://github.com/yandex-cloud/terraform-provider-yandex/releases/download/v${V}/terraform-provider-yandex_${V}_darwin_amd64.zip"

cat > .terraformrc <<'RC'
provider_installation {
  filesystem_mirror { path = "./.terraform-mirror" }
  direct { exclude = ["registry.terraform.io/*/*"] }
}
RC

TF_CLI_CONFIG_FILE="$PWD/.terraformrc" terraform -chdir=envs/dev init -backend=false
```

`plan` и `apply` без облака не пройдут: нужны действующий токен и реальные
идентификаторы.
