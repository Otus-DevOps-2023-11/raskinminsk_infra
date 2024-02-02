#terraform {
#  required_providers {
#    yandex = {
#      source = "yandex-cloud/yandex"
#    }
#  }
#  required_version = ">= 0.13"

  backend "s3" {
    endpoints  = "storage.yandexcloud.net"
    bucket     = "raskinmsk-tfstate"
    region     = "ru-central1"
    key        = "terraform1.tfstate"
    shared_credentials_file = "storage.key"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
#}
