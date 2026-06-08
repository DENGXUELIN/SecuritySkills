# Benign: App Service and staging slot disable SCM and FTP publishing basic auth
# while using non-basic deployment and audit/policy evidence.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.13"
    }
  }
}

resource "azurerm_resource_group" "prod" {
  name     = "rg-app-prod"
  location = "eastus"
}

resource "azurerm_service_plan" "prod" {
  name                = "asp-prod"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_linux_web_app" "api" {
  name                                           = "app-prod-api"
  resource_group_name                            = azurerm_resource_group.prod.name
  location                                       = azurerm_resource_group.prod.location
  service_plan_id                                = azurerm_service_plan.prod.id
  https_only                                     = true
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  identity {
    type = "SystemAssigned"
  }

  site_config {
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
    http2_enabled       = true
  }

  app_settings = {
    DEPLOYMENT_AUTH_MODE       = "oidc-federated-service-principal"
    PUBLISH_PROFILE_ROTATED_AT = "2026-06-01T00:00:00Z"
  }
}

resource "azapi_resource" "api_scm_basic_auth" {
  type      = "Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01"
  name      = "scm"
  parent_id = azurerm_linux_web_app.api.id

  body = {
    properties = {
      allow = false
    }
  }
}

resource "azapi_resource" "api_ftp_basic_auth" {
  type      = "Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01"
  name      = "ftp"
  parent_id = azurerm_linux_web_app.api.id

  body = {
    properties = {
      allow = false
    }
  }
}

resource "azurerm_linux_web_app_slot" "staging" {
  name                                           = "staging"
  app_service_id                                 = azurerm_linux_web_app.api.id
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  site_config {
    ftps_state = "Disabled"
  }
}

resource "azapi_resource" "slot_scm_basic_auth" {
  type      = "Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies@2022-09-01"
  name      = "scm"
  parent_id = azurerm_linux_web_app_slot.staging.id

  body = {
    properties = {
      allow = false
    }
  }
}

resource "azapi_resource" "slot_ftp_basic_auth" {
  type      = "Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies@2022-09-01"
  name      = "ftp"
  parent_id = azurerm_linux_web_app_slot.staging.id

  body = {
    properties = {
      allow = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "appservice_audit" {
  name                       = "send-appservice-audit-logs"
  target_resource_id         = azurerm_linux_web_app.api.id
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-sec/providers/Microsoft.OperationalInsights/workspaces/law-sec"

  enabled_log {
    category = "AppServiceAuditLogs"
  }
}

resource "azurerm_role_definition" "prevent_basic_auth_reenable" {
  name        = "Prevent App Service Basic Publishing Auth"
  scope       = "/subscriptions/00000000-0000-0000-0000-000000000000"
  description = "Prevents lower-privileged operators from enabling App Service SCM or FTP basic publishing credentials."

  permissions {
    actions = ["*"]
    not_actions = [
      "Microsoft.Web/sites/basicPublishingCredentialsPolicies/write",
      "Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies/write",
    ]
  }

  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
}
