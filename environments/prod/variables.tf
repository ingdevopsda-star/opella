variable "environment" {
  description = "Nom de l'environnement"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "project" {
  description = "Nom du projet — utilisé dans les tags et le nommage"
  type        = string
}

variable "vnet_address_space" {
  description = "Plage d'adresses CIDR du VNET"
  type        = list(string)
}

variable "vm_size" {
  description = "Taille de la machine virtuelle Azure"
  type        = string
}

variable "vm_admin_username" {
  description = "Nom d'utilisateur administrateur de la VM"
  type        = string
}

variable "vm_ssh_public_key" {
  description = "Clé publique SSH pour l'authentification à la VM — passer via TF_VAR_vm_ssh_public_key ou secret CI"
  type        = string
  sensitive   = true
}

variable "unique_suffix" {
  description = "Suffixe alphanumérique pour garantir l'unicité globale du compte de stockage"
  type        = string
}
