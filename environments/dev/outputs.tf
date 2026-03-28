output "resource_group_name" {
  description = "Nom du groupe de ressources de l'environnement dev"
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "ID du VNET dev — utile pour le peering ou les diagnostics"
  value       = module.vnet.vnet_id
}

output "subnet_ids" {
  description = "Map des IDs de sous-réseaux dev"
  value       = module.vnet.subnet_ids
}

output "vm_public_ip" {
  description = "IP publique de la VM dev — adresse de connexion SSH"
  value       = azurerm_public_ip.vm.ip_address
}

output "storage_account_name" {
  description = "Nom du compte de stockage dev"
  value       = azurerm_storage_account.this.name
}
