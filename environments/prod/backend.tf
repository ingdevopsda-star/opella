terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "stterraformingdev2026" # remplacer par le nom généré lors du bootstrap
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}
