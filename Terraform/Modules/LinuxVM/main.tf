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
  computer_name         = var.VM_name
  admin_ssh_key {
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQe55Cuo73CvLPmQ7Tt8V9Wm/vAHoxRfWE8r8Jcn9DUbvPX6097isGUc0m7rBqKVL8usVGTlvaAHgCvqFZ27Oyzvu+ww5fW45dUuR4uRB0XTF6TBMfu0hDdzl19hmCJ4o0+C/6ukFvRFKMkro/1/SM2RhTUPSJShqNrsG3QJZATj4EcL5j64D5XrtYj9hkY11VizwdNFJp4/aQ3FBbLh2zyLzuUJnS/4L3aFTzDDTzpbf6UBUiZ8+Nosswv+X0ENT3HkeeAnw8qmx/H60jOCf3dS7U5LEj+jbD8bzqEUSukfi2ri4OMtjrdwFjl7qmxyiWQCQkSe/HX0zhluZKWqQHPOq+fuzR0TMzH2fPCnA9jrGUkUXtPiCJixzhhwksP74vFXCUH0cgBarlBXm7f3hEOjZyCLg1xwFMptdcHGHtl0As6wt6xwwBR5VJOOpmg9nADn3QEam4D+933hqXEHbrruO2N9SYO0VKF9j+sL044fV23osqPYqsi/MC5MCCmwE= hari@Inspiron-7573"
    username   = "Ansible"
  }
  depends_on            = [
    azurerm_network_interface.PublicNIC, azurerm_public_ip.PublicIP
  ]
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