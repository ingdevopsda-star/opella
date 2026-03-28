terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  common_tags = {
    environment = var.environment
    region      = var.location
    managed_by  = "terraform"
    project     = var.project
  }

  subnets = {
    "snet-vm" = {
      cidr_block        = "10.0.1.0/24"
      service_endpoints = []
      nsg_rules = {
        "allow-ssh" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = var.allowed_ssh_cidr
          destination_address_prefix = "*"
        }
        "deny-all-inbound" = {
          priority                   = 4000
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      }
    }
    "snet-storage" = {
      cidr_block        = "10.0.2.0/24"
      service_endpoints = ["Microsoft.Storage"]
      nsg_rules         = {}
    }
  }
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.environment}-${var.location}"
  location = var.location
  tags     = local.common_tags
}

module "vnet" {
  source              = "../../modules/vnet"
  name                = "vnet-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  subnets             = local.subnets
  tags                = local.common_tags
}

resource "azurerm_storage_account" "this" {
  name                            = "st${var.environment}${replace(var.location, "-", "")}${var.unique_suffix}"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  depends_on = [module.vnet]

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [module.vnet.subnet_ids["snet-storage"]]
    bypass                     = ["AzureServices"]
  }

  tags = local.common_tags
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_public_ip" "vm" {
  name                = "pip-vm-${var.environment}-${var.location}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_network_interface" "vm" {
  name                = "nic-vm-${var.environment}-${var.location}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids["snet-vm"]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }

  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "vm-${var.environment}-${var.location}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username

  network_interface_ids = [azurerm_network_interface.vm.id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.vm_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = local.common_tags
}
