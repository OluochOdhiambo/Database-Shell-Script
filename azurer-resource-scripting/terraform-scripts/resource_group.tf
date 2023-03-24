resource "azurerm_resource_group" "learningazure_rg" {
    name = var.base_name
    location = var.location
}