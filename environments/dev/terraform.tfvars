environment        = "dev"
location           = "eastus"
project            = "opella"
vnet_address_space = ["10.0.0.0/16"]
allowed_ssh_cidr   = "10.0.0.1/32" # override via TF_VAR_allowed_ssh_cidr or DEV_ALLOWED_SSH_CIDR secret
vm_size            = "Standard_B1s"
vm_admin_username  = "azureuser"
unique_suffix      = "001"
