resource "azurerm_resource_group" "prod" {
  name     = "rg-prod-disk-evidence"
  location = "eastus"
}

resource "azurerm_virtual_network" "prod" {
  name                = "vnet-prod"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "private_link" {
  name                 = "snet-private-link"
  resource_group_name  = azurerm_resource_group.prod.name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = ["10.20.10.0/24"]
}

resource "azurerm_disk_access" "prod" {
  name                = "da-prod-export"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location
}

resource "azurerm_private_endpoint" "disk_access" {
  name                = "pe-disk-access"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name
  subnet_id           = azurerm_subnet.private_link.id

  private_service_connection {
    name                           = "disk-access"
    private_connection_resource_id = azurerm_disk_access.prod.id
    is_manual_connection           = false
    subresource_names              = ["disks"]
  }
}

resource "azurerm_managed_disk" "orders" {
  name                          = "orders-prod-osdisk"
  location                      = azurerm_resource_group.prod.location
  resource_group_name           = azurerm_resource_group.prod.name
  storage_account_type          = "Premium_LRS"
  create_option                 = "Empty"
  disk_size_gb                  = 256
  network_access_policy         = "AllowPrivate"
  public_network_access_enabled = false
  disk_access_id                = azurerm_disk_access.prod.id
}

resource "azurerm_snapshot" "orders_backup" {
  name                          = "orders-prod-validated-snapshot"
  location                      = azurerm_resource_group.prod.location
  resource_group_name           = azurerm_resource_group.prod.name
  create_option                 = "Copy"
  source_resource_id            = azurerm_managed_disk.orders.id
  network_access_policy         = "AllowPrivate"
  public_network_access_enabled = false
  disk_access_id                = azurerm_disk_access.prod.id
}

locals {
  disk_export_evidence = {
    inventory_complete              = true
    disk_access_private_endpoint    = azurerm_private_endpoint.disk_access.name
    export_capable_principals       = ["breakglass-disk-export-operators"]
    approval_required               = true
    max_sas_duration_seconds        = 3600
    revoke_access_evidence_required = true
    activity_log_alert              = "Microsoft.Compute/disks/beginGetAccess/action"
  }
}
