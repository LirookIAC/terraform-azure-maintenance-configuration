resource "azurerm_maintenance_configuration" "maintenance_configuration" {
  name                     = var.maintenance_configuration_name
  resource_group_name      = var.maintenance_configuration_resource_group
  location                 = var.maintenance_configuration_location
  tags                     = var.tags
  scope                    = "InGuestPatch"
  in_guest_user_patch_mode = var.in_guest_user_patch_mode
  install_patches {
    # Linux-specific settings
    linux {
      classifications_to_include    = var.linux_classifications_to_include
      package_names_mask_to_exclude = var.linux_package_names_mask_to_exclude
      package_names_mask_to_include = var.linux_package_names_mask_to_include
    }

    # Windows-specific settings
    windows {
      classifications_to_include = var.windows_classifications_to_include
      kb_numbers_to_exclude      = var.windows_kb_numbers_to_exclude
      kb_numbers_to_include      = var.windows_kb_numbers_to_include
    }
    reboot = var.reboot_preference
  }
  window {
    duration        = var.window.duration
    recur_every     = var.window.recur_every
    start_date_time = var.window.start_date_time
    time_zone       = var.window.time_zone
  }
}