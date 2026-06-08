# Benign Fixture: Pre-Index Redaction With Hash Linkage

## Scenario

An authentication log pipeline redacts sensitive values before indexing while preserving enough provenance for investigation. Raw access is break-glass only and downstream exports inherit the same masking rules.

## Evidence

```yaml
pipeline: auth-service-to-siem
event_id: evt-8820
redaction:
  stage: pre-index
  raw_authorization_header: tokenized
  url_query_token: tokenized
  user_email: masked
  linkage_hash: sha256(event_id + field_name + secret_version)
provenance:
  parser_version: auth-parser-4.8.2
  enrichment_sources:
    - idp-directory
    - geoip
access_control:
  analyst_view_raw_values: false
  break_glass_role: security-privacy-approver
  break_glass_expiry_hours: 4
  break_glass_audit_log: enabled
exports:
  csv_export_inherits_redaction: true
  ticket_sync_inherits_redaction: true
sample_verification:
  positive_token_sample_masked: true
  negative_status_code_sample_preserved: true
  nested_query_sample_masked: true
```

## Expected Assessment

- Do not flag sensitive-field leakage when evidence shows pre-index redaction and controlled raw access.
- Record redaction and provenance status as passing.
- Preserve event IDs, hashes, timestamps, and ATT&CK context without exposing sensitive values.
