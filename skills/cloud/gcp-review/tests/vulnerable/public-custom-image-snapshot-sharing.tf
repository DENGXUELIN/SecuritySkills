resource "google_compute_image" "prod_clone" {
  project     = "private-images"
  name        = "prod-payments-clone"
  source_disk = google_compute_disk.payments.self_link

  labels = {
    data_classification = "regulated"
    owner               = "unknown"
  }
}

resource "google_compute_image_iam_member" "public_image_user" {
  project = google_compute_image.prod_clone.project
  image   = google_compute_image.prod_clone.name
  role    = "roles/compute.imageUser"
  member  = "allAuthenticatedUsers"
}

resource "google_project_iam_member" "image_project_viewer" {
  project = google_compute_image.prod_clone.project
  role    = "roles/viewer"
  member  = var.contractor_group_member
}

resource "google_compute_snapshot" "payments_snapshot" {
  project     = "private-images"
  name        = "payments-prod-snapshot-20260608"
  source_disk = google_compute_disk.payments.name

  labels = {
    data_classification = "regulated"
    owner               = "unknown"
  }
}

resource "google_compute_snapshot_iam_member" "external_snapshot_user" {
  project  = google_compute_snapshot.payments_snapshot.project
  snapshot = google_compute_snapshot.payments_snapshot.name
  role     = "roles/compute.storageAdmin"
  member   = var.external_ops_group_member
}

locals {
  image_snapshot_sharing_gaps = {
    all_authenticated_users      = true
    unapproved_external_group    = var.external_ops_group_member
    project_viewer_discoverable  = true
    sanitization_evidence        = "missing"
    approval_ticket              = "missing"
    expiry                       = "missing"
    audit_log_monitoring         = "missing"
  }
}
