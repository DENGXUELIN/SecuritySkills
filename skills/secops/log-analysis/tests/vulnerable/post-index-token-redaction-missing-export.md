# Vulnerable Fixture: Sensitive Token Redacted in Raw View but Exported

## Scenario

A SIEM masks bearer tokens in the rendered raw event view, but parsed URL query fields and ticket exports still contain the original token. Analysts can export the unredacted field without break-glass approval.

## Evidence

```yaml
pipeline: web-proxy-to-siem
event_id: evt-7781
raw_event:
  redaction_stage: rendered_view_only
  displayed_authorization: "[REDACTED]"
parsed_fields:
  url.path: /oauth/callback
  url.query.token:
    data_class: live-session-token
    redacted: false
    source: parser
  user.email:
    data_class: pii
    redacted: false
    source: idp-enrichment
storage:
  broad_index_contains_raw_token: true
  analyst_role_can_query_raw: true
exports:
  csv_export_contains_url_query_token: true
  ticket_sync_contains_user_email: true
sample_verification:
  positive_token_sample_masked: false
  nested_query_sample_masked: false
```

## Expected Assessment

- Flag a **High** or **Critical** finding depending on whether the token is live and privileged.
- Note that raw display masking is insufficient because parsed and exported fields preserve sensitive values.
- Require pre-index redaction or tokenization, role-gated raw access, downstream export controls, and verification samples.
- Do not reproduce the actual token value in the report.
