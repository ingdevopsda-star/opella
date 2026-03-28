output "resource_group_name" {
  description = "Nom du groupe de ressources de l'environnement prod"
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "ID du VNET prod — utile pour le peering ou les diagnostics"
  value       = module.vnet.vnet_id
}

output "subnet_ids" {
  description = "Map des IDs de sous-réseaux prod"
  value       = module.vnet.subnet_ids
}

output "vm_private_ip" {
  description = "IP privée de la VM prod — accès via Azure Bastion ou VPN uniquement"
  value       = azurerm_network_interface.vm.private_ip_address
}

output "storage_account_name" {
  description = "Nom du compte de stockage prod"
  value       = azurerm_storage_account.this.name
}
