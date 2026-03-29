# Module VNET Azure

Module Terraform réutilisable pour provisionner un Azure Virtual Network avec sous-réseaux et groupes de sécurité réseau (NSG).

## Fonctionnalités

- Création du Virtual Network avec plages CIDR configurables
- Sous-réseaux dynamiques définis par l'appelant (map)
- Un NSG par sous-réseau avec règles injectées par l'appelant
- Service Endpoints configurables par sous-réseau
- Tags systématiquement appliqués à toutes les ressources

## Documentation automatique

Ce README est régénéré automatiquement par [`terraform-docs`](https://terraform-docs.io/) via le hook pre-commit.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Liste des plages d'adresses CIDR du VNET | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Région Azure où déployer le VNET | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Nom du Virtual Network | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Nom du groupe de ressources cible | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map de sous-réseaux à créer. Chaque entrée définit le CIDR, les service endpoints et les règles NSG associées. | <pre>map(object({<br/>    cidr_block        = string<br/>    service_endpoints = optional(list(string), [])<br/>    nsg_rules = optional(map(object({<br/>      priority                   = number<br/>      direction                  = string<br/>      access                     = string<br/>      protocol                   = string<br/>      source_port_range          = string<br/>      destination_port_range     = string<br/>      source_address_prefix      = string<br/>      destination_address_prefix = string<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags à appliquer à toutes les ressources du module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_ids"></a> [nsg\_ids](#output\_nsg\_ids) | Map nom → ID de chaque NSG — permet d'ajouter des règles supplémentaires en dehors du module |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map nom → ID de chaque sous-réseau — utilisé pour attacher des NICs, Private Endpoints et règles de pare-feu |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | ID du Virtual Network — nécessaire pour le peering VNET et les diagnostics |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Nom du Virtual Network — référence dans d'autres modules ou ressources |
<!-- END_TF_DOCS -->
