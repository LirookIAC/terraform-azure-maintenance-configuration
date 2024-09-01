variable "maintenance_configuration_name" {
  type        = string
  description = "The name of  the maintenance configuration"
}

variable "maintenance_configuration_location" {
  type        = string
  description = "The location of the maintenance configuration"
}

variable "maintenance_configuration_resource_group" {
  type        = string
  description = "The resource group of the maintenance configuration"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
}

variable "linux_classifications_to_include" {
  description = "List of Classification category of patches to be patched for Linux. Possible values are Critical, Security, and Other."
  type        = list(string)
  default     = ["Critical", "Security", "Other"]
  validation {
    condition = all(
      [for c in var.linux_classifications_to_include : contains(["Critical", "Security", "Other"], c)]
    )
    error_message = "Valid values for linux_classifications_to_include are Critical, Security, and Other."
  }
}

variable "linux_package_names_mask_to_exclude" {
  description = "List of package names to be excluded from patching for Linux."
  type        = list(string)
  default     = []
}

variable "linux_package_names_mask_to_include" {
  description = "List of package names to be included for patching for Linux."
  type        = list(string)
  default     = []
}

variable "windows_classifications_to_include" {
  description = "List of Classification category of patches to be patched for Windows. Possible values are Critical, Security, UpdateRollup, FeaturePack, ServicePack, Definition, Tools, and Updates."
  type        = list(string)
  default     = ["Critical", "Security", "UpdateRollup", "FeaturePack", "ServicePack", "Definition", "Tools", "Updates"]
  validation {
    condition = all(
      [for c in var.windows_classifications_to_include : contains(["Critical", "Security", "UpdateRollup", "FeaturePack", "ServicePack", "Definition", "Tools", "Updates"], c)]
    )
    error_message = "Valid values for windows_classifications_to_include are Critical, Security, UpdateRollup, FeaturePack, ServicePack, Definition, Tools, and Updates."
  }
}

variable "windows_kb_numbers_to_exclude" {
  description = "List of KB numbers to be excluded from patching for Windows."
  type        = list(string)
  default     = []
}

variable "windows_kb_numbers_to_include" {
  description = "List of KB numbers to be included for patching for Windows."
  type        = list(string)
  default     = []
}

variable "reboot_preference" {
  description = "Possible reboot preference after patch operation completion. Possible values are Always, IfRequired, and Never. This property only applies when scope is set to InGuestPatch."
  type        = string
  default     = "IfRequired"
  validation {
    condition     = contains(["Always", "IfRequired", "Never"], var.reboot_preference)
    error_message = "Invalid value for reboot_preference. Must be one of Always, IfRequired, or Never."
  }
}

variable "in_guest_user_patch_mode" {
  description = "The in-guest user patch mode. Possible values are Platform or User."
  type        = string
  default     = "Platform"

  validation {
    condition     = contains(["Platform", "User"], var.in_guest_user_patch_mode)
    error_message = "The in_guest_user_patch_mode must be either 'Platform' or 'User'."
  }
}

locals {
  # Regex pattern for recurrence format with optional Offset
  recur_every_pattern = "^[0-9]+(Month|Week|Day|Year) (First|Second|Third|Fourth|Last) (Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)( Offset[0-9]+)?$"
  # List of all supported time zones
  supported_time_zones = [
    "Dateline Standard Time",
    "UTC-11",
    "Aleutian Standard Time",
    "Hawaiian Standard Time",
    "Marquesas Standard Time",
    "Alaskan Standard Time",
    "UTC-09",
    "Pacific Standard Time (Mexico)",
    "UTC-08",
    "Pacific Standard Time",
    "US Mountain Standard Time",
    "Mountain Standard Time (Mexico)",
    "Mountain Standard Time",
    "Yukon Standard Time",
    "Central America Standard Time",
    "Central Standard Time",
    "Easter Island Standard Time",
    "Central Standard Time (Mexico)",
    "Canada Central Standard Time",
    "SA Pacific Standard Time",
    "Eastern Standard Time (Mexico)",
    "Eastern Standard Time",
    "Haiti Standard Time",
    "Cuba Standard Time",
    "US Eastern Standard Time",
    "Turks And Caicos Standard Time",
    "Paraguay Standard Time",
    "Atlantic Standard Time",
    "Venezuela Standard Time",
    "Central Brazilian Standard Time",
    "SA Western Standard Time",
    "Pacific SA Standard Time",
    "Newfoundland Standard Time",
    "Tocantins Standard Time",
    "E. South America Standard Time",
    "SA Eastern Standard Time",
    "Argentina Standard Time",
    "Montevideo Standard Time",
    "Magallanes Standard Time",
    "Saint Pierre Standard Time",
    "Bahia Standard Time",
    "UTC-02",
    "Greenland Standard Time",
    "Mid-Atlantic Standard Time",
    "Azores Standard Time",
    "Cape Verde Standard Time",
    "UTC",
    "GMT Standard Time",
    "Greenwich Standard Time",
    "Sao Tome Standard Time",
    "Morocco Standard Time",
    "W. Europe Standard Time",
    "Central Europe Standard Time",
    "Romance Standard Time",
    "Central European Standard Time",
    "W. Central Africa Standard Time",
    "GTB Standard Time",
    "Middle East Standard Time",
    "Egypt Standard Time",
    "E. Europe Standard Time",
    "West Bank Standard Time",
    "South Africa Standard Time",
    "FLE Standard Time",
    "Israel Standard Time",
    "South Sudan Standard Time",
    "Kaliningrad Standard Time",
    "Sudan Standard Time",
    "Libya Standard Time",
    "Namibia Standard Time",
    "Jordan Standard Time",
    "Arabic Standard Time",
    "Syria Standard Time",
    "Turkey Standard Time",
    "Arab Standard Time",
    "Belarus Standard Time",
    "Russian Standard Time",
    "E. Africa Standard Time",
    "Volgograd Standard Time",
    "Iran Standard Time",
    "Arabian Standard Time",
    "Astrakhan Standard Time",
    "Azerbaijan Standard Time",
    "Russia Time Zone 3",
    "Mauritius Standard Time",
    "Saratov Standard Time",
    "Georgian Standard Time",
    "Caucasus Standard Time",
    "Afghanistan Standard Time",
    "West Asia Standard Time",
    "Qyzylorda Standard Time",
    "Ekaterinburg Standard Time",
    "Pakistan Standard Time",
    "India Standard Time",
    "Sri Lanka Standard Time",
    "Nepal Standard Time",
    "Central Asia Standard Time",
    "Bangladesh Standard Time",
    "Omsk Standard Time",
    "Myanmar Standard Time",
    "SE Asia Standard Time",
    "Altai Standard Time",
    "W. Mongolia Standard Time",
    "North Asia Standard Time",
    "N. Central Asia Standard Time",
    "Tomsk Standard Time",
    "China Standard Time",
    "North Asia East Standard Time",
    "Singapore Standard Time",
    "W. Australia Standard Time",
    "Taipei Standard Time",
    "Ulaanbaatar Standard Time",
    "Aus Central W. Standard Time",
    "Transbaikal Standard Time",
    "Tokyo Standard Time",
    "North Korea Standard Time",
    "Korea Standard Time",
    "Yakutsk Standard Time",
    "Cen. Australia Standard Time",
    "AUS Central Standard Time",
    "E. Australia Standard Time",
    "AUS Eastern Standard Time",
    "West Pacific Standard Time",
    "Tasmania Standard Time",
    "Vladivostok Standard Time",
    "Lord Howe Standard Time",
    "Bougainville Standard Time",
    "Russia Time Zone 10",
    "Magadan Standard Time",
    "Norfolk Standard Time",
    "Sakhalin Standard Time",
    "Central Pacific Standard Time",
    "Russia Time Zone 11",
    "New Zealand Standard Time",
    "UTC+12",
    "Fiji Standard Time",
    "Kamchatka Standard Time",
    "Chatham Islands Standard Time",
    "UTC+13",
    "Tonga Standard Time",
    "Samoa Standard Time",
    "Line Islands Standard Time"
  ]
}

variable "maintainence_window" {
  description = "Configuration for the maintenance window."
  type = object({
    start_date_time      = string
    expiration_date_time = optional(string)
    duration             = optional(string)
    time_zone            = string
    recur_every          = optional(string)
  })

  validation {
    condition = alltrue([
      # Validate start_date_time
      can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}$", var.maintainence_window.start_date_time)),
      # Validate expiration_date_time if provided
      var.maintainence_window.expiration_date_time == null || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}$", var.maintainence_window.expiration_date_time)),
      # Validate duration if provided
      var.maintainence_window.duration == null || can(regex("^[0-9]{2}:[0-9]{2}$", var.maintainence_window.duration)),
      # Validate time_zone
      contains(
        ["Dateline Standard Time",
          "UTC-11",
          "Aleutian Standard Time",
          "Hawaiian Standard Time",
          "Marquesas Standard Time",
          "Alaskan Standard Time",
          "UTC-09",
          "Pacific Standard Time (Mexico)",
          "UTC-08",
          "Pacific Standard Time",
          "US Mountain Standard Time",
          "Mountain Standard Time (Mexico)",
          "Mountain Standard Time",
          "Yukon Standard Time",
          "Central America Standard Time",
          "Central Standard Time",
          "Easter Island Standard Time",
          "Central Standard Time (Mexico)",
          "Canada Central Standard Time",
          "SA Pacific Standard Time",
          "Eastern Standard Time (Mexico)",
          "Eastern Standard Time",
          "Haiti Standard Time",
          "Cuba Standard Time",
          "US Eastern Standard Time",
          "Turks And Caicos Standard Time",
          "Paraguay Standard Time",
          "Atlantic Standard Time",
          "Venezuela Standard Time",
          "Central Brazilian Standard Time",
          "SA Western Standard Time",
          "Pacific SA Standard Time",
          "Newfoundland Standard Time",
          "Tocantins Standard Time",
          "E. South America Standard Time",
          "SA Eastern Standard Time",
          "Argentina Standard Time",
          "Montevideo Standard Time",
          "Magallanes Standard Time",
          "Saint Pierre Standard Time",
          "Bahia Standard Time",
          "UTC-02",
          "Greenland Standard Time",
          "Mid-Atlantic Standard Time",
          "Azores Standard Time",
          "Cape Verde Standard Time",
          "UTC",
          "GMT Standard Time",
          "Greenwich Standard Time",
          "Sao Tome Standard Time",
          "Morocco Standard Time",
          "W. Europe Standard Time",
          "Central Europe Standard Time",
          "Romance Standard Time",
          "Central European Standard Time",
          "W. Central Africa Standard Time",
          "GTB Standard Time",
          "Middle East Standard Time",
          "Egypt Standard Time",
          "E. Europe Standard Time",
          "West Bank Standard Time",
          "South Africa Standard Time",
          "FLE Standard Time",
          "Israel Standard Time",
          "South Sudan Standard Time",
          "Kaliningrad Standard Time",
          "Sudan Standard Time",
          "Libya Standard Time",
          "Namibia Standard Time",
          "Jordan Standard Time",
          "Arabic Standard Time",
          "Syria Standard Time",
          "Turkey Standard Time",
          "Arab Standard Time",
          "Belarus Standard Time",
          "Russian Standard Time",
          "E. Africa Standard Time",
          "Volgograd Standard Time",
          "Iran Standard Time",
          "Arabian Standard Time",
          "Astrakhan Standard Time",
          "Azerbaijan Standard Time",
          "Russia Time Zone 3",
          "Mauritius Standard Time",
          "Saratov Standard Time",
          "Georgian Standard Time",
          "Caucasus Standard Time",
          "Afghanistan Standard Time",
          "West Asia Standard Time",
          "Qyzylorda Standard Time",
          "Ekaterinburg Standard Time",
          "Pakistan Standard Time",
          "India Standard Time",
          "Sri Lanka Standard Time",
          "Nepal Standard Time",
          "Central Asia Standard Time",
          "Bangladesh Standard Time",
          "Omsk Standard Time",
          "Myanmar Standard Time",
          "SE Asia Standard Time",
          "Altai Standard Time",
          "W. Mongolia Standard Time",
          "North Asia Standard Time",
          "N. Central Asia Standard Time",
          "Tomsk Standard Time",
          "China Standard Time",
          "North Asia East Standard Time",
          "Singapore Standard Time",
          "W. Australia Standard Time",
          "Taipei Standard Time",
          "Ulaanbaatar Standard Time",
          "Aus Central W. Standard Time",
          "Transbaikal Standard Time",
          "Tokyo Standard Time",
          "North Korea Standard Time",
          "Korea Standard Time",
          "Yakutsk Standard Time",
          "Cen. Australia Standard Time",
          "AUS Central Standard Time",
          "E. Australia Standard Time",
          "AUS Eastern Standard Time",
          "West Pacific Standard Time",
          "Tasmania Standard Time",
          "Vladivostok Standard Time",
          "Lord Howe Standard Time",
          "Bougainville Standard Time",
          "Russia Time Zone 10",
          "Magadan Standard Time",
          "Norfolk Standard Time",
          "Sakhalin Standard Time",
          "Central Pacific Standard Time",
          "Russia Time Zone 11",
          "New Zealand Standard Time",
          "UTC+12",
          "Fiji Standard Time",
          "Kamchatka Standard Time",
          "Chatham Islands Standard Time",
          "UTC+13",
          "Tonga Standard Time",
          "Samoa Standard Time",
          "Line Islands Standard Time"
        ], var.maintainence_window.time_zone),
      # Validate recur_every if provided
      var.maintainence_window.recur_every == null || can(regex("^[0-9]+(Month|Week|Day|Year) (First|Second|Third|Fourth|Last) (Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)( Offset[0-9]+)?$", var.maintainence_window.recur_every))
    ])
    error_message = "Invalid value for one or more of the following fields: start_date_time, expiration_date_time, duration, time_zone, recur_every."
  }
}





