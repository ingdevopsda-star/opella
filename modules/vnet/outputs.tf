output "vnet_id" {
  description = "ID du Virtual Network — nécessaire pour le peering VNET et les diagnostics"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Nom du Virtual Network — référence dans d'autres modules ou ressources"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map nom → ID de chaque sous-réseau — utilisé pour attacher des NICs, Private Endpoints et règles de pare-feu"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "nsg_ids" {
  description = "Map nom → ID de chaque NSG — permet d'ajouter des règles supplémentaires en dehors du module"
  value       = { for k, v in azurerm_network_security_group.this : k => v.id }
}
