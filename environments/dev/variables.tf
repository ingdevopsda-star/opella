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

variable "allowed_ssh_cidr" {
  description = "Plage CIDR autorisée pour SSH — doit être une IP spécifique (ex: 1.2.3.4/32), jamais 0.0.0.0/0"
  type        = string

  validation {
    condition     = var.allowed_ssh_cidr != "0.0.0.0/0" && can(cidrnetmask(var.allowed_ssh_cidr))
    error_message = "allowed_ssh_cidr doit être une plage CIDR valide et ne peut pas être 0.0.0.0/0."
  }
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

variable "terraform_ip_allowlist" {
  description = "IPv4 addresses allowed through the storage account firewall — set via TF_VAR_terraform_ip_allowlist when running locally, never commit real IPs"
  type        = list(string)
  default     = []
}
