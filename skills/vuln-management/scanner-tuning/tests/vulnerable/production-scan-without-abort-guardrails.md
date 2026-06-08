# Vulnerable Fixture: Production Scan Without Abort Guardrails

## Scenario

A weekly production scan is classified as tuned because dangerous/DoS plugins are disabled, credentialed checks are enabled, and concurrency is limited.

## Evidence Presented

```json
{
  "scan_policy": "weekly-production-authenticated",
  "dangerous_plugins": "disabled",
  "max_simultaneous_hosts": 20,
  "max_checks_per_host": 8,
  "web_checks": "enabled_all_http_services",
  "credentialed_checks": true,
  "scan_window": "generic_off_peak",
  "auth_behavior": {
    "windows_protocols": ["SMB", "WinRM", "RDP"],
    "retry_limit_per_protocol": 5,
    "ad_lockout_threshold": 5,
    "canary_scan_completed": false
  },
  "web_behavior": {
    "authenticated_admin_portal": true,
    "safe_method_only": false,
    "blocked_routes": [],
    "test_tenant": false
  },
  "abort_thresholds": {
    "target_cpu": null,
    "http_5xx_rate": null,
    "account_lockouts": null,
    "scanner_error_rate": null
  },
  "observed_impact": {
    "service_account_locked": true,
    "http_5xx_rate_percent": 8.1,
    "records_changed_by_scanner": 14
  }
}
```

## Expected Finding

Classify this policy as not production-safe. It fails `SCAN-SAFE-01`, `SCAN-SAFE-02`, `SCAN-SAFE-03`, `SCAN-SAFE-07`, and `SCAN-SAFE-08`: lockout-safe authentication was not proven, web checks can mutate state, no health/abort thresholds exist, no owner-approved recovery path is recorded, and post-scan side effects were not reconciled.
