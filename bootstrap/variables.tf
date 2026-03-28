variable "location" {
  description = "Région Azure pour le backend d'état"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Nom du compte de stockage pour l'état Terraform (doit être globalement unique, 3-24 caractères alphanumériques minuscules)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Le nom du compte de stockage doit contenir entre 3 et 24 caractères alphanumériques minuscules."
  }
}
