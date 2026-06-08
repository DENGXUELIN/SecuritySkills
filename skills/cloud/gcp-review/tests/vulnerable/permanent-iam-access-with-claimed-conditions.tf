# Vulnerable: comments and planned dates claim temporary access, but deployed IAM
# bindings are permanent or use unsupported basic/public grants.

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

variable "contractor_group_member" {
  type = string
}

variable "external_partner_member" {
  type = string
}

resource "google_project_iam_member" "contractor_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = var.contractor_group_member

  # Ticket says this expires on 2026-07-01, but there is no CEL condition.
}

resource "google_project_iam_member" "partner_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = var.external_partner_member

  # Manual reminder is not enforceable time-bound access.
}

resource "google_project_iam_binding" "public_viewer_claimed_temporary" {
  project = var.project_id
  role    = "roles/viewer"
  members = ["allAuthenticatedUsers"]

  condition {
    title       = "claimed_temporary_public_viewer"
    description = "Public/basic grant must not be credited as a safe conditional boundary."
    expression  = "request.time < timestamp(\"2026-07-01T00:00:00Z\")"
  }
}

resource "google_service_account_iam_member" "weak_scope" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/prod-deploy@${var.project_id}.iam.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"
  member             = var.contractor_group_member

  condition {
    title       = "claimed_scoped_deployment"
    description = "Condition has an expiry but no resource or access-context scope."
    expression  = "request.time < timestamp(\"2026-07-01T00:00:00Z\")"
  }
}
