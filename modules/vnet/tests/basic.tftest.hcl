mock_provider "azurerm" {}

# Test 1: minimal VNET with no subnets
run "vnet_minimal" {
  command = plan

  variables {
    name                = "vnet-test"
    location            = "eastus"
    resource_group_name = "rg-test"
    address_space       = ["10.0.0.0/16"]
  }

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-test"
    error_message = "VNET name should be 'vnet-test'"
  }

  assert {
    condition     = azurerm_virtual_network.this.location == "eastus"
    error_message = "VNET location should be 'eastus'"
  }

  assert {
    condition     = contains(azurerm_virtual_network.this.address_space, "10.0.0.0/16")
    error_message = "VNET address space should contain '10.0.0.0/16'"
  }

  assert {
    condition     = length(azurerm_subnet.this) == 0
    error_message = "No subnets should be created when none are defined"
  }

  assert {
    condition     = length(azurerm_network_security_group.this) == 0
    error_message = "No NSGs should be created when no subnets are defined"
  }
}

# Test 2: VNET with subnets and NSG rules
run "vnet_with_subnets_and_nsg" {
  command = plan

  variables {
    name                = "vnet-dev"
    location            = "eastus"
    resource_group_name = "rg-dev"
    address_space       = ["10.0.0.0/16"]
    subnets = {
      "snet-vm" = {
        cidr_block = "10.0.1.0/24"
        nsg_rules = {
          "allow-ssh" = {
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "22"
            source_address_prefix      = "10.0.0.1/32"
            destination_address_prefix = "*"
          }
          "deny-all" = {
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
      }
    }
  }

  assert {
    condition     = length(azurerm_subnet.this) == 2
    error_message = "Should create 2 subnets"
  }

  assert {
    condition     = length(azurerm_network_security_group.this) == 2
    error_message = "Should create 1 NSG per subnet (2 total)"
  }

  assert {
    condition     = length(azurerm_network_security_rule.this) == 2
    error_message = "Should create 2 NSG rules (allow-ssh + deny-all)"
  }

  assert {
    condition     = azurerm_network_security_rule.this["snet-vm__allow-ssh"].destination_port_range == "22"
    error_message = "SSH rule should target port 22"
  }

  assert {
    condition     = azurerm_network_security_rule.this["snet-vm__allow-ssh"].access == "Allow"
    error_message = "SSH rule access should be 'Allow'"
  }

  assert {
    condition     = azurerm_network_security_rule.this["snet-vm__deny-all"].access == "Deny"
    error_message = "Deny-all rule access should be 'Deny'"
  }

  assert {
    condition     = azurerm_network_security_rule.this["snet-vm__deny-all"].priority > azurerm_network_security_rule.this["snet-vm__allow-ssh"].priority
    error_message = "Deny-all rule should have lower priority (higher number) than allow-ssh"
  }
}

# Test 3: module tag is always merged into resource tags
run "module_tag_merged" {
  command = plan

  variables {
    name                = "vnet-tagged"
    location            = "westeurope"
    resource_group_name = "rg-test"
    address_space       = ["192.168.0.0/16"]
    tags = {
      environment = "test"
      project     = "opella"
    }
  }

  assert {
    condition     = azurerm_virtual_network.this.tags["module"] == "vnet"
    error_message = "Module should always inject 'module = vnet' tag"
  }

  assert {
    condition     = azurerm_virtual_network.this.tags["environment"] == "test"
    error_message = "Caller tags should be preserved after merge"
  }
}

# Test 4: NSG associations are created for every subnet
run "nsg_associated_to_each_subnet" {
  command = plan

  variables {
    name                = "vnet-assoc"
    location            = "eastus"
    resource_group_name = "rg-test"
    address_space       = ["10.2.0.0/16"]
    subnets = {
      "snet-a" = { cidr_block = "10.2.1.0/24" }
      "snet-b" = { cidr_block = "10.2.2.0/24" }
      "snet-c" = { cidr_block = "10.2.3.0/24" }
    }
  }

  assert {
    condition     = length(azurerm_subnet_network_security_group_association.this) == 3
    error_message = "Every subnet should have an NSG association"
  }
}
