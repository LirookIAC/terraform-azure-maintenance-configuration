resource "azurerm_maintenance_configuration" "example" {
  name                = var.maintenance_configuration_name
  resource_group_name = var.maintenance_configuration_resource_group
  location            = var.maintenance_configuration_location
  scope               = "InGuestPatch"

  tags = var.tags
}