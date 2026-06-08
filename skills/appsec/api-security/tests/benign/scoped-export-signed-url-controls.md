# Benign: Scoped Export Signed URL Controls

## Review Target

```yaml
api:
  style: REST
  workflow: async bulk report export
  endpoints:
    create: POST /api/v1/reports/export
    status: GET /api/v1/reports/export/{job_id}
    download: POST /api/v1/reports/export/{job_id}/download-token
    cleanup: background retention job

create_export:
  auth_required: true
  function_permission: export_reports
  tenant_scope: current_user.tenant_id
  object_authorization: enforced_before_job_create
  filters_frozen_at_creation: true
  frozen_scope_hash: sha256:8a77
  row_limit: 50000
  byte_limit: 250mb
  concurrency_limit_per_user: 2
  concurrency_limit_per_tenant: 10
  timeout: 15m
  cancellation_supported: true
  audit_fields:
    - actor
    - tenant
    - filters
    - frozen_scope_hash
    - requested_at
    - correlation_id

job_status:
  auth_required: true
  tenant_ownership_check: true
  requester_or_admin_check: true
  metadata_redaction: hides_storage_key

download:
  auth_required: true
  tenant_ownership_check: true
  requester_or_admin_check: true
  role_recheck: export_reports
  scope_hash_recheck: true
  signed_url:
    ttl: 5m
    reusable: false
    one_time_use: true
    revocable_after_role_change: true
    not_logged: true
    referrer_policy: no-referrer

storage:
  bucket: exports-private
  object_key_pattern: tenant/{tenant_id}/user/{user_id}/job/{job_id}.csv
  acl: private
  tenant_prefix: enforced
  retention: 24h
  cleanup_failed_exports: true
  incident_revocation_runbook: RUNBOOK-EXPORT-REVOKE

observed_tests:
  cross_tenant_job_status: 404
  cross_tenant_download_token: 404
  role_revoked_after_create: download_token_denied
  expired_signed_url: 403
  reused_signed_url: 403
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Create authorization | Pass | Function, tenant, object, and frozen-filter scope checks run before job creation. |
| Status authorization | Pass | Job status requires tenant ownership and requester/admin authorization. |
| Download authorization | Pass | Download token re-checks tenant, requester/admin, role, and frozen scope hash. |
| Signed URL lifecycle | Pass | URL is five minutes, one-time-use, revocable after role changes, and not logged. |
| Storage isolation | Pass | Object key is tenant/user/job scoped in a private bucket. |
| Resource controls | Pass | Row, byte, concurrency, timeout, cancellation, retention, and cleanup controls exist. |
| Auditability | Pass | Audit events include actor, tenant, filters, object count or scope hash, download, cleanup, and correlation ID. |

## Reviewer Notes

This evidence supports marking the export workflow as controlled. Keep export limits proportional to data sensitivity and retest cross-tenant status/download attempts whenever storage or signed URL code changes.
