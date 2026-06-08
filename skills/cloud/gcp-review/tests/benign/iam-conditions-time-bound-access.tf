# Benign: temporary and scoped access is enforced by IAM Conditions, with drift
# monitoring and break-glass evidence.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30"
    }
  }
}

variable "project_id" {
  type = string
}

variable "approved_builder_group_member" {
  type = string
}

variable "deployer_group_member" {
  type = string
}

variable "breakglass_group_member" {
  type = string
}

resource "google_service_account" "deploy" {
  project      = var.project_id
  account_id   = "prod-deploy"
  display_name = "Production deployment service account"
}

resource "google_project_iam_member" "temporary_image_builder" {
  project = var.project_id
  role    = "roles/compute.imageUser"
  member  = var.approved_builder_group_member

  condition {
    title       = "temporary_image_build_access"
    description = "Expires after approved image build window ticket CHG-2026-0701."
    expression  = "request.time < timestamp(\"2026-07-01T00:00:00Z\")"
  }
}

resource "google_service_account_iam_member" "scoped_deployer" {
  service_account_id = google_service_account.deploy.name
  role               = "roles/iam.serviceAccountUser"
  member             = var.deployer_group_member

  condition {
    title       = "deploy_only_prod_service_account"
    description = "Restricts impersonation to the approved deployment service account."
    expression  = "resource.name.endsWith(\"/serviceAccounts/prod-deploy\")"
  }
}

resource "google_project_iam_member" "breakglass_observer" {
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = var.breakglass_group_member

  condition {
    title       = "breakglass_incident_window"
    description = "Emergency observer access approved for incident INC-2026-0042 with post-use review."
    expression  = "request.time < timestamp(\"2026-06-15T12:00:00Z\")"
  }
}

resource "google_project_service" "cloudasset" {
  project = var.project_id
  service = "cloudasset.googleapis.com"
}

resource "google_logging_metric" "iam_condition_removed" {
  project = var.project_id
  name    = "iam-condition-removed-or-weakened"
  filter  = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.bindingDeltas:*"
}

resource "google_monitoring_alert_policy" "iam_condition_drift" {
  project      = var.project_id
  display_name = "IAM condition removed or weakened"
  combiner     = "OR"

  conditions {
    display_name = "SetIamPolicy changed IAM bindings"
    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/iam-condition-removed-or-weakened\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      duration        = "0s"
    }
  }
}
