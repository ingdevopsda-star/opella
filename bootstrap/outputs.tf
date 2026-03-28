output "resource_group_name" {
  description = "Nom du groupe de ressources contenant le backend d'état"
  value       = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  description = "Nom du compte de stockage — à renseigner dans backend.tf de chaque environnement"
  value       = azurerm_storage_account.tfstate.name
}

output "container_name" {
  description = "Nom du conteneur blob pour l'état Terraform"
  value       = azurerm_storage_container.tfstate.name
}
