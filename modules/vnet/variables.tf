variable "name" {
  description = "Nom du Virtual Network"
  type        = string
}

variable "location" {
  description = "Région Azure où déployer le VNET"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources cible"
  type        = string
}

variable "address_space" {
  description = "Liste des plages d'adresses CIDR du VNET"
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "Au moins une plage CIDR doit être définie."
  }
}

variable "subnets" {
  description = "Map de sous-réseaux à créer. Chaque entrée définit le CIDR, les service endpoints et les règles NSG associées."
  type = map(object({
    cidr_block        = string
    service_endpoints = optional(list(string), [])
    nsg_rules = optional(map(object({
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), {})
  }))
  default = {}
}

variable "tags" {
  description = "Tags à appliquer à toutes les ressources du module"
  type        = map(string)
  default     = {}
}
