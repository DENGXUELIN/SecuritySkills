# Vulnerable: runtime App Service hardening is enabled, but deployment-plane SCM and
# FTP publishing basic auth remain enabled or unproven for production and slot.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
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
  name                = "app-prod-api"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location
  service_plan_id     = azurerm_service_plan.prod.id
  https_only          = true

  # Runtime authentication does not protect Kudu/SCM, WebDeploy, ZipDeploy,
  # Local Git, or FTP publishing endpoints.
  auth_settings_v2 {
    auth_enabled = true
  }

  # FTP protocol is disabled, but the publishing credential policies are still
  # enabled. This must fail AZ-APP-PUBLISH-02 and AZ-APP-PUBLISH-03.
  ftp_publish_basic_authentication_enabled       = true
  webdeploy_publish_basic_authentication_enabled = true

  site_config {
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
    http2_enabled       = true
  }

  app_settings = {
    DEPLOYMENT_AUTH_MODE        = "publish-profile-basic-auth"
    PUBLISH_PROFILE_ROTATION    = "planned-next-quarter"
    APPSERVICE_AUDIT_LOG_STATUS = "not-enabled"
  }
}

resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.api.id

  # Slot parity gap: staging still accepts SCM publishing basic auth and has no
  # child basicPublishingCredentialsPolicies export proving both policies off.
  webdeploy_publish_basic_authentication_enabled = true

  site_config {
    ftps_state = "Disabled"
  }
}

resource "azurerm_source_control_token" "legacy_github" {
  type  = "GitHub"
  token = var.legacy_publish_profile_token
}

variable "legacy_publish_profile_token" {
  type      = string
  sensitive = true
}
