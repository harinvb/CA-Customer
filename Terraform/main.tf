provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
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

module "v-net" {
  source              = "./Modules/v-net"
  network_name        = "${var.Instance}_vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "subnet" {
  source               = "./Modules/subnet"
  virtual_network_name = module.v-net.virtual_network_name
  resource_group_name  = module.v-net.resource_group_name
  subnet_name          = "${var.Instance}_subnet"
  depends_on = [module.v-net]
}

module "VM" {
  source              = "./Modules/LinuxVM"
  location            = var.location
  resource_group_name = module.subnet.resource_group_name
  VM_name             = var.Instance
  subnet_id           = module.subnet.subnet_id
  depends_on = [module.subnet,module.v-net]
}
