# terraform-azure-maintenance-configuration# Azure Maintenance Configuration Module

# Azure Maintenance Configuration Module

This module creates an Azure Maintenance Configuration resource. The maintenance configuration helps manage updates and patches for your Azure resources.

## Usage

To use this module, follow these steps:

1. **Define Module Source**

   Specify the source path or URL of the module in your Terraform configuration. This could be a local path or a remote repository.

2. **Set Required Variables**

   Configure the following variables to tailor the maintenance configuration to your needs:

   - **`maintenance_configuration_name`**
     - **Type**: `string`
     - **Description**: The name of the maintenance configuration.
     - **Default**: (None, required)
   
   - **`maintenance_configuration_location`**
     - **Type**: `string`
     - **Description**: The location where the maintenance configuration will be applied.
     - **Default**: (None, required)
   
   - **`maintenance_configuration_resource_group`**
     - **Type**: `string`
     - **Description**: The resource group to which the maintenance configuration belongs.
     - **Default**: (None, required)
   
   - **`tags`**
     - **Type**: `map(string)`
     - **Description**: Tags to assign to the resources, provided as a map of key-value pairs.
     - **Default**: `{}` (Empty map)
   
3. **Configure Patch Categories for Linux**

   - **`linux_classifications_to_include`**
     - **Type**: `list(string)`
     - **Description**: List categories of patches to be applied to Linux systems (e.g., Critical, Security, Other).
     - **Default**: `["Critical", "Security", "Other"]`
   
   - **`linux_package_names_mask_to_exclude`**
     - **Type**: `list(string)`
     - **Description**: List of package names to be excluded from patching for Linux.
     - **Default**: `[]` (Empty list)
   
   - **`linux_package_names_mask_to_include`**
     - **Type**: `list(string)`
     - **Description**: List of package names to be included for patching on Linux.
     - **Default**: `[]` (Empty list)
   
4. **Configure Patch Categories for Windows**

   - **`windows_classifications_to_include`**
     - **Type**: `list(string)`
     - **Description**: List categories of patches to be applied to Windows systems (e.g., Critical, Security, Updates).
     - **Default**: `["Critical", "Security", "UpdateRollup", "FeaturePack", "ServicePack", "Definition", "Tools", "Updates"]`
   
   - **`windows_kb_numbers_to_exclude`**
     - **Type**: `list(string)`
     - **Description**: List of KB numbers to be excluded from patching for Windows.
     - **Default**: `[]` (Empty list)
   
   - **`windows_kb_numbers_to_include`**
     - **Type**: `list(string)`
     - **Description**: List of KB numbers to be included for patching on Windows.
     - **Default**: `[]` (Empty list)
   
5. **Set Reboot Preference**

   - **`reboot_preference`**
     - **Type**: `string`
     - **Description**: Possible reboot preference after patch operation completion (e.g., Always, IfRequired, Never). This applies only when scope is set to `InGuestPatch`.
     - **Default**: `IfRequired`
     - **Possible Values**: `Always`, `IfRequired`, `Never`
   
6. **Specify In-Guest User Patch Mode**

   - **`in_guest_user_patch_mode`**
     - **Type**: `string`
     - **Description**: The in-guest user patch mode (e.g., Platform or User).
     - **Default**: `Platform`
     - **Possible Values**: `Platform`, `User`
   
7. **Configure Maintenance Window**

   - **`maintainence_window`**
     - **Type**: `object`
     - **Description**: Configuration for the maintenance window, including:
       - **`start_date_time`** (string): The start date and time of the maintenance window (format: `YYYY-MM-DD HH:MM`).
       - **`expiration_date_time`** (string, optional): The optional expiration date and time (format: `YYYY-MM-DD HH:MM`).
       - **`duration`** (string, optional): The optional duration of the maintenance window (format: `HH:MM`).
       - **`time_zone`** (string): The time zone for the maintenance window.
       - **`recur_every`** (string, optional): Optional recurrence pattern.
     - **Default**: (All fields required except `expiration_date_time`, `duration`, and `recur_every`)

## Example Configuration

To use the module, you need to specify the above variables in your Terraform configuration. This setup will create an Azure Maintenance Configuration with the provided settings.

### Summary

- **Define the module source.**
- **Configure required and optional variables to suit your needs.**
- **Apply the configuration using Terraform.**

For additional information, consult the Terraform documentation or reach out to your team for support with module integration and usage.



