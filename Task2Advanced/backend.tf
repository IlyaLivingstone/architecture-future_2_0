terraform {
  # use_lockfile в backend "s3" появился в Terraform 1.10
  required_version = ">= 1.10"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }

  # параметры backend передаются через -backend-config, в коде их нет
  backend "s3" {}
}
