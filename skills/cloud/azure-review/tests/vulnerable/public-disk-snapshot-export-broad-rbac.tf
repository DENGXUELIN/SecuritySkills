resource "azurerm_resource_group" "prod" {
  name     = "rg-prod-disk-export-risk"
  location = "eastus"
}

resource "azurerm_managed_disk" "payments" {
  name                          = "payments-prod-osdisk"
  location                      = azurerm_resource_group.prod.location
  resource_group_name           = azurerm_resource_group.prod.name
  storage_account_type          = "Premium_LRS"
  create_option                 = "Empty"
  disk_size_gb                  = 512
  network_access_policy         = "AllowAll"
  public_network_access_enabled = true
}

resource "azurerm_snapshot" "payments_backup" {
  name                          = "payments-prod-snapshot"
  location                      = azurerm_resource_group.prod.location
  resource_group_name           = azurerm_resource_group.prod.name
  create_option                 = "Copy"
  source_resource_id            = azurerm_managed_disk.payments.id
  network_access_policy         = "AllowAll"
  public_network_access_enabled = true
}

resource "azurerm_role_definition" "disk_export_operator" {
  name        = "Broad Disk Export Operator"
  scope       = azurerm_resource_group.prod.id
  description = "Allows disk and snapshot SAS export for a broad operations group."

  permissions {
    actions = [
      "Microsoft.Compute/disks/read",
      "Microsoft.Compute/disks/beginGetAccess/action",
      "Microsoft.Compute/disks/endGetAccess/action",
      "Microsoft.Compute/snapshots/read",
      "Microsoft.Compute/snapshots/beginGetAccess/action",
      "Microsoft.Compute/snapshots/endGetAccess/action"
    ]
    not_actions = []
  }

  assignable_scopes = [azurerm_resource_group.prod.id]
}

resource "azurerm_role_assignment" "broad_export" {
  scope              = azurerm_resource_group.prod.id
  role_definition_id = azurerm_role_definition.disk_export_operator.role_definition_resource_id
  principal_id       = var.all_operations_group_object_id
}

locals {
  disk_export_gaps = {
    missing_disk_access_private_endpoint = true
    sas_duration_seconds                 = 86400
    revoke_access_evidence               = "missing"
    activity_log_alert                   = "missing"
    approval_ticket                      = "missing"
    snapshot_reviewed_separately         = false
  }
}
