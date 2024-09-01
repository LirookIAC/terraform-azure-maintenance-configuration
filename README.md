# terraform-azure-maintenance-configuration

# Azure Maintenance Configuration Module

This module creates an Azure Maintenance Configuration resource. The maintenance configuration helps manage updates and patches for your Azure VMs Guest OS.

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
         ### Format and Examples for recur_every
         The `recur_every` variable supports different recurrence patterns based on frequency and optional offsets. The general format is:
         [<interval>][<frequency>][<day-of-week>][<offset>]
         #### Frequency Intervals
         
         - **`Day`**: Repeats every day.
         - **`Week`**: Repeats every week.
         - **`Month`**: Repeats every month.
         - **`Year`**: Repeats every year.
         
         #### Day of Week
         
         Specifies which day(s) of the week the recurrence should apply to, e.g., `Monday`, `Tuesday`, etc.
         
         #### Offset (Optional)
         
         The offset can modify the recurrence to apply to a specific occurrence of a day or a week in the month, e.g., `First`, `Second`, `Last`, or `Offset<N>`.
         
         ### Examples
         
         Here are some examples of how to use the `recur_every` variable:
         
         1. **Monthly Recurrence with Specific Weekday and Offset**
            1Month Third Tuesday Offset4
            - **Explanation**: Repeats every month on the third Tuesday of the month, with an additional offset of 4 days.
         2. **Monthly Recurrence with Last Weekday**
            1Month Last Tuesday
            - **Explanation**: Repeats every month on the last Tuesday of the month.
         3. **Weekly Recurrence with Specific Weekday**
            3Week Tuesday
            - **Explanation**: Repeats every 3 weeks on Tuesday. No offset is available for this pattern.
         4. **Daily Recurrence**
            3Day
            - **Explanation**: Repeats every 3 days. No specific day of the week or offset is applied.
            
            ### Notes
            
            - The `recur_every` pattern can be combined with other parameters to create complex schedules.
            - The interval and frequency dictate how often the recurrence happens, while the optional day-of-week and offset provide additional customization.
            
            Ensure that the chosen pattern aligns with your maintenance window requirements and is supported by the system handling the configuration.
     - **Default**: (All fields required except `expiration_date_time`, `duration`, and `recur_every`)

## Example Usage

This section provides an example of how to use the Azure Maintenance Configuration module in your Terraform configuration.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "maintenance_configuration" {
  source = "git::https://github.com/LirookIAC/terraform-azure-maintenance-configuration.git"

  # Pass any required variables to the module
  maintenance_configuration_name            = "testMC"
  maintenance_configuration_location         = "West Europe"
  maintenance_configuration_resource_group  = "test2"
  in_guest_user_patch_mode                  = "User"
  maintainence_window = {
    duration        = "03:55"
    recur_every     = "1Month Second Tuesday Offset4"
    start_date_time = "2024-09-13 03:00"
    time_zone       = "India Standard Time"
  }
  tags = {
    "env" = "test"
  }
}

output "maintenance_configuration_id" {
  value = module.maintenance_configuration.maintenance_configuration_id
}
```
## Explanation

- **`terraform` Block**: Specifies the required provider (`azurerm`) and its version.

- **`provider "azurerm"` Block**: Configures the Azure provider with default settings.

- **`module "maintenance_configuration"` Block**: Defines the module and passes variables to configure the maintenance setup.
  - **`maintenance_configuration_name`**: Sets the name of the maintenance configuration.
  - **`maintenance_configuration_location`**: Specifies the Azure location for the configuration.
  - **`maintenance_configuration_resource_group`**: Provides the resource group where the maintenance configuration will be applied.
  - **`in_guest_user_patch_mode`**: Defines the in-guest user patch mode (e.g., "User").
  - **`maintainence_window`**: Configures the maintenance window, including:
    - **`duration`**: Duration of the maintenance window.
    - **`recur_every`**: Recurrence pattern for the maintenance window.
    - **`start_date_time`**: Start date and time for the maintenance window.
    - **`time_zone`**: Time zone of the maintenance window.
  - **`tags`**: Assigns tags to the resources for organizational purposes.

- **`output "maintenance_configuration_id"` Block**: Outputs the ID of the created maintenance configuration.

This example provides a template for setting up an Azure Maintenance Configuration using the module. Customize the variable values according to your requirements.




