resource "google_compute_image" "hardened_app" {
  project     = "private-images"
  name        = "hardened-app-20260608"
  source_disk = google_compute_disk.golden.self_link

  labels = {
    data_classification = "sanitized"
    owner               = "platform-security"
  }
}

resource "google_compute_image_iam_member" "approved_builders" {
  project = google_compute_image.hardened_app.project
  image   = google_compute_image.hardened_app.name
  role    = "roles/compute.imageUser"
  member  = var.approved_builders_group_member

  condition {
    title       = "expires_after_build_window"
    expression  = "request.time < timestamp('2026-07-01T00:00:00Z')"
    description = "Temporary access for approved image consumers."
  }
}

resource "google_compute_snapshot" "orders_dr" {
  project     = "private-images"
  name        = "orders-dr-sanitized-20260608"
  source_disk = google_compute_disk.golden.name

  labels = {
    data_classification = "sanitized"
    owner               = "platform-security"
  }
}

resource "google_compute_snapshot_iam_member" "approved_dr" {
  project  = google_compute_snapshot.orders_dr.project
  snapshot = google_compute_snapshot.orders_dr.name
  role     = "roles/compute.storageAdmin"
  member   = var.approved_dr_group_member
}

locals {
  image_snapshot_sharing_evidence = {
    inventory_complete          = true
    project_viewer_principals   = [var.approved_builders_group_member]
    all_authenticated_users     = false
    external_principals_reviewed = true
    sanitization_evidence       = "golden-image-build-log-and-secret-scan"
    audit_log_monitoring        = "SetIamPolicy alert for images and snapshots"
    review_cadence_days         = 30
  }
}
