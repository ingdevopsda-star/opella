terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "stterraformstate001" # remplacer par le nom généré lors du bootstrap
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}
