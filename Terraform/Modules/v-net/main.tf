resource "azurerm_virtual_network" "v_net" {
  address_space       = ["172.17.0.0/18"]
  location            = var.location
  name                = var.network_name
  resource_group_name = var.resource_group_name
}
