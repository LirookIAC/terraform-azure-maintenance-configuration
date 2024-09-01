resource "azurerm_maintenance_configuration" "maintenance_configuration" {
  name                = var.maintenance_configuration_name
  resource_group_name = var.maintenance_configuration_resource_group
  location            = var.maintenance_configuration_location
  scope               = "InGuestPatch"

  tags = var.tags
}