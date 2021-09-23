resource "azurerm_linux_virtual_machine" "LinuxVM" {
  admin_username        = "Ansible"
  admin_password        = "Ansible"
  location              = var.location
  name                  = var.VM_name
  network_interface_ids = [azurerm_network_interface.PublicNIC.id]
  size                  = "Standard_B1s"
  resource_group_name   = var.resource_group_name
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  computer_name = var.VM_name
  admin_ssh_key {
    public_key = file("~/.ssh/id_rsa.pub")
    username   = "Ansible"
  }
  depends_on = [
  azurerm_network_interface.PublicNIC, azurerm_public_ip.PublicIP]
}
resource "azurerm_network_interface" "PublicNIC" {
  location            = var.location
  name                = "${var.VM_name}_NIC"
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.VM_name}_ip_Configuration"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PublicIP.id
    subnet_id                     = var.subnet_id
  }
}

resource "azurerm_network_interface_security_group_association" "nic" {
  network_interface_id      = azurerm_network_interface.PublicNIC.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {
  location            = var.location
  name                = var.VM_name
  resource_group_name = var.resource_group_name
  security_rule {
    access                     = "Allow"
    direction                  = "InBound"
    name                       = "allow_in_8080_ports"
    priority                   = 4000
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
  }
  security_rule {
    access                     = "Allow"
    direction                  = "OutBound"
    name                       = "allow_out_8080_ports"
    priority                   = 4000
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "8080"
  }
  security_rule {
    access                     = "Allow"
    direction                  = "InBound"
    name                       = "ssh_in"
    priority                   = 4001
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
  }
  security_rule {
    access                     = "Allow"
    direction                  = "OutBound"
    name                       = "ssh_out"
    priority                   = 4001
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
  }
}


resource "azurerm_public_ip" "PublicIP" {
  allocation_method   = "Dynamic"
  location            = var.location
  name                = "${var.VM_name}_public_ip"
  resource_group_name = var.resource_group_name
}