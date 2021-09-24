provider "azurerm" {
  features {
  }
}

terraform {
  backend "azurerm" {
    container_name       = "terraform"
    key                  = "CA_Assignment_Ansible_Managed_Node_State"
    resource_group_name  = "cloud-shell-storage-centralindia"
    storage_account_name = "csg100320015f749fb9"
  }
}

resource "azurerm_resource_group" "resource_group" {
  location = var.location
  name     = var.resource_group_name
  provider = azurerm
}

module "v-net" {
  source              = "./Modules/v-net"
  network_name        = "${var.Instance}_vnet"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
}

module "subnet" {
  source               = "./Modules/subnet"
  virtual_network_name = module.v-net.virtual_network_name
  resource_group_name  = azurerm_resource_group.resource_group.name
  subnet_name          = "${var.Instance}_subnet"
}

module "VM" {
  source              = "./Modules/LinuxVM"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  VM_name             = var.Instance
  subnet_id           = module.subnet.subnet_id
}
