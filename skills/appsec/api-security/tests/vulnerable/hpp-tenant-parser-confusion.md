# Vulnerable: HPP Tenant Parser Confusion

## Review Target

```yaml
api:
  style: REST
  endpoint: GET /api/v1/accounts
  sensitive_parameters:
    - tenant_id
    - account_id
    - include_closed
  duplicate_parameter_policy: undocumented
  gateway:
    product: api-gateway
    duplicate_query_behavior: first_value
    authorization:
      tenant_source: first tenant_id
      decision: allow if user belongs to tenant
  validator:
    duplicate_query_behavior: first_value
    schema:
      tenant_id: string
  app_handler:
    framework: express
    duplicate_query_behavior: array
    tenant_source: last tenant_id
    account_filter_source: last account_id
  cache:
    key_source: first tenant_id + first account_id
  audit_log:
    tenant_source: first tenant_id
    duplicate_attempt_logged: false
  downstream_service:
    service: account-ledger
    duplicate_query_behavior: last_value
  negative_tests:
    duplicate_tenant_id: missing
    duplicate_account_id: missing

attack_request: |
  GET /api/v1/accounts?tenant_id=public&tenant_id=admin&account_id=123&account_id=999 HTTP/1.1
  Host: api.example.test
  Authorization: Bearer user-token

observed_behavior:
  gateway_authorized_tenant: public
  app_loaded_tenant: admin
  downstream_account_id: 999
  cache_key_tenant: public
  audit_log_tenant: public
  response_status: 200
  response_data: admin tenant account 999
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| API-HPP-01 | High | `tenant_id` and `account_id` accept duplicate values without rejection or deterministic canonicalization. |
| API-HPP-02 | High | Gateway/validator use first value while app and downstream service use last value. |
| API-HPP-03 | High | Authorization checks tenant `public` while business logic loads tenant `admin`. |
| API-HPP-04 | Medium | Cache key and audit log use first values while handler and downstream service use last values. |
| API-HPP-05 | Medium | Duplicate query and mixed layer behavior are not covered in tests. |
| API-HPP-06 | Medium | Negative tests and logs are missing for duplicate tenant and account parameters. |

## Reviewer Notes

Map this to API1/API5 when duplicate object or tenant parameters bypass authorization, API8 for parser inconsistency, and CWE-235. Require duplicate rejection or one canonical representation before authorization, cache key generation, audit logging, and downstream calls.
