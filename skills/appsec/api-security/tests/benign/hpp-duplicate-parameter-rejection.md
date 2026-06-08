# Benign: HPP Duplicate Parameter Rejection

## Review Target

```yaml
api:
  style: REST
  endpoint: GET /api/v1/accounts
  sensitive_parameters:
    - tenant_id
    - account_id
    - include_closed
  duplicate_parameter_policy: reject_at_gateway
  gateway:
    product: api-gateway
    duplicate_query_behavior: reject_security_sensitive_duplicates
    rejection_status: 400
    rejection_body: duplicate parameter rejected
    normalized_parameter_header: x-canonical-params-sha256
  validator:
    duplicate_query_behavior: reject
    schema:
      tenant_id:
        type: string
        duplicate_allowed: false
  app_handler:
    framework: express
    source: gateway_normalized_single_value_map
    duplicate_arrays_accepted: false
  cache:
    key_source: canonical parameter map
  audit_log:
    duplicate_attempt_logged: true
    fields:
      - endpoint
      - parameter_name
      - caller_id
      - tenant_id
      - request_id
  downstream_service:
    service: account-ledger
    source: canonical parameter map
  negative_tests:
    duplicate_tenant_id: tests/api/test_hpp_rejects_duplicate_tenant.py::test_duplicate_tenant_id_rejected
    duplicate_account_id: tests/api/test_hpp_rejects_duplicate_account.py::test_duplicate_account_id_rejected
    mixed_query_body_id: tests/api/test_hpp_rejects_mixed_locations.py::test_mixed_query_body_ids_rejected

test_request: |
  GET /api/v1/accounts?tenant_id=public&tenant_id=admin&account_id=123 HTTP/1.1
  Host: api.example.test
  Authorization: Bearer user-token

observed_behavior:
  gateway_result: rejected
  status: 400
  app_handler_called: false
  downstream_called: false
  audit_event: duplicate_parameter_rejected
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Sensitive parameter inventory | Pass | Tenant, account, and filter parameters are listed as single-value. |
| Gateway behavior | Pass | Gateway rejects duplicate security-sensitive query parameters before authorization. |
| App behavior | Pass | Handler receives only the canonical parameter map and does not accept duplicate arrays. |
| Cache/signature/audit consistency | Pass | Cache and downstream calls use the same canonical parameter map; audit logs duplicate rejections. |
| Mixed locations | Pass | Tests cover duplicate query values and mixed query/body IDs. |
| Negative tests | Pass | Focused tests prove duplicate tenant/account parameters are rejected with no downstream call. |

## Reviewer Notes

This evidence supports closing the HPP gate as controlled for this endpoint. Keep the sensitive-parameter inventory current and repeat the same parser-consistency tests for redirects, prices, signatures, roles, and other security-sensitive parameters.
