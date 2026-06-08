# Vulnerable: Cross-Tenant Export Signed URL

## Review Target

```yaml
api:
  style: REST
  workflow: async bulk report export
  endpoints:
    create: POST /api/v1/reports/export
    status: GET /api/v1/reports/export/{job_id}
    download: GET /api/v1/reports/export/{job_id}/download
    cleanup: background retention job

create_export:
  auth_required: true
  function_permission: export_reports
  tenant_scope: current_user.tenant_id
  filters_frozen_at_creation: false
  row_limit: none
  byte_limit: none
  concurrency_limit_per_tenant: none
  audit_fields:
    - actor
    - requested_at

job_status:
  auth_required: true
  tenant_ownership_check: false
  reveals_object_key: true

download:
  auth_required: true
  job_lookup: ExportJob.get(job_id)
  tenant_ownership_check: false
  requester_ownership_check: false
  signed_url:
    ttl: 7d
    reusable: true
    revocable_after_role_change: false
    one_time_use: false
    logged_in_access_logs: true
    referrer_policy: unset

storage:
  bucket: exports
  object_key_pattern: reports/{job_id}.csv
  acl: public-read
  tenant_prefix: shared
  retention: 30d
  cleanup_failed_exports: false

observed_attack:
  attacker_tenant: tenant-a
  victim_tenant: tenant-b
  guessed_job_id: exp_2026_000348
  download_status: 302
  signed_url_status: 200
  downloaded_rows: 820000
  contains_pii: true
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| API-EXPORT-01 | High | Export scope is not frozen at creation and has no row, byte, or concurrency limits. |
| API-EXPORT-02 | Critical | Status and download endpoints lack tenant/user ownership checks for `job_id`. |
| API-EXPORT-03 | Critical | A tenant-a user can redeem a tenant-b export job and download 820000 PII rows. |
| API-EXPORT-04 | High | Signed URL is reusable for 7 days, logged, not revocable after role change, and lacks one-time-use behavior. |
| API-EXPORT-05 | High | Export object uses shared predictable key pattern and public-read ACL. |
| API-EXPORT-06 | Medium | Export workflow has no row, byte, concurrency, timeout, cancellation, or tenant quota controls. |
| API-EXPORT-07 | Medium | Audit records omit tenant, filters, object count, byte size, download, cancellation, cleanup, and correlation ID. |

## Reviewer Notes

Map this primarily to API1 for job/download BOLA, API4 for unbounded exports, and API5 if export/download functions lack role checks. Require per-phase authorization and signed URL lifecycle controls before accepting the export workflow as safe.
