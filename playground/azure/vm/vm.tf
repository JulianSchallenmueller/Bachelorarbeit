terraform {
  backend "azurerm" {
    resource_group_name  = "backend-storage"
    storage_account_name = "jsastorage"
    container_name       = "tfstate"
    key                  = "playground.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "jsa_playground" {
  name     = "jsa-playground"
  location = "West Europe"
}

resource "azurerm_virtual_network" "jsa_playground" {
  name                = "network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.jsa_playground.location
  resource_group_name = azurerm_resource_group.jsa_playground.name
}

resource "azurerm_subnet" "jsa_playground" {
  name                 = "jsa_playground"
  resource_group_name  = azurerm_resource_group.jsa_playground.name
  virtual_network_name = azurerm_virtual_network.jsa_playground.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "jsa_playground" {
  name                = "jsa_playground"
  location            = azurerm_resource_group.jsa_playground.location
  resource_group_name = azurerm_resource_group.jsa_playground.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.jsa_playground.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "jsa_playground" {
  name                  = "vm"
  location              = azurerm_resource_group.jsa_playground.location
  resource_group_name   = azurerm_resource_group.jsa_playground.name
  vm_size               = "Standard_B2s"

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  network_interface_ids = [azurerm_network_interface.jsa_playground.id]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
    disk_size_gb = 30
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}