# Benign Fixture: Production Scan With Canary And Abort Controls

## Scenario

A production vulnerability scan is approved after a canary run validates credential behavior, web/API checks are restricted to safe actions, health telemetry has stop thresholds, and the owner signs off on recovery steps.

## Evidence Presented

```json
{
  "scan_policy": "weekly-production-safe-authenticated",
  "change_ticket": "CHG-2026-0608-441",
  "owner": "platform-operations",
  "dangerous_plugins": "disabled",
  "max_simultaneous_hosts": 8,
  "max_checks_per_host": 4,
  "credentialed_checks": true,
  "auth_guardrails": {
    "canary_scan": "pass_25_representative_hosts",
    "retry_limit_per_protocol": 1,
    "denied_protocols": ["RDP"],
    "ad_lockout_threshold_reviewed": true,
    "abort_on_lockouts": 1
  },
  "web_api_guardrails": {
    "safe_method_only": true,
    "route_denylist": ["/admin/disable-user", "/billing/send-invoice", "/keys/rotate"],
    "test_tenant": "scanner-prod-sandbox",
    "rollback_reconciliation": "enabled"
  },
  "health_abort_thresholds": {
    "target_cpu_percent": 85,
    "http_5xx_rate_percent": 2,
    "scanner_error_rate_percent": 5,
    "edr_service_restart_count": 1,
    "owner_escalation": "on-call-platform"
  },
  "allowlist_governance": {
    "waf_exception_expiry": "2026-06-09T08:00:00Z",
    "siem_monitoring_enabled": true,
    "ids_visibility_retained": true
  },
  "post_scan_review": {
    "lockout_report": "zero_lockouts",
    "application_error_review": "below_threshold",
    "changed_record_reconciliation": "no_unapproved_changes"
  }
}
```

## Expected Result

Treat this policy as production-safe for the reviewed scope. It satisfies `SCAN-SAFE-01` through `SCAN-SAFE-08`: authentication retry and lockout controls are proven, state-changing actions are blocked, health and abort thresholds exist, allowlists are governed, quotas and recovery are documented, and post-scan impact review is complete.
