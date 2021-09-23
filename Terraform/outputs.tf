output "ip_address" {
  value = module.VM.IP
}

output "admin_username" {
  value     = module.VM.admin_username
  sensitive = false
}

output "admin_password" {
  value     = module.VM.admin_password
  sensitive = true
}