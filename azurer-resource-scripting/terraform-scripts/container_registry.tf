resource "azurerm_container_registry" "learningazure_cr" {
    name = var.base_name
    resource_group_name = azurerm_resource_group.learningazure_rg.name
    location = var.location
    admin_enabled = true
    sku = "Basic"
}

output "registry_hostname" {
    value = azurerm_container_registry.learningazure_cr.login_server
    sensitive = true
}

output "registry_un" {
    value = azurerm_container_registry.learningazure_cr.admin_username
    sensitive = true
}

output "registry_pw" {
    value = azurerm_container_registry.learningazure_cr.admin_password
    sensitive = true
}