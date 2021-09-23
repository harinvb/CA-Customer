output "IP" {
  value = azurerm_linux_virtual_machine.LinuxVM.public_ip_address
}

output "Host_ID" {
  value = azurerm_linux_virtual_machine.LinuxVM.dedicated_host_id
}

output "admin_username" {
  value = azurerm_linux_virtual_machine.LinuxVM.admin_username
}

output "admin_password" {
  value = azurerm_linux_virtual_machine.LinuxVM.admin_password
}