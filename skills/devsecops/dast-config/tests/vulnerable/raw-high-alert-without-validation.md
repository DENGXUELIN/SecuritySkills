# Vulnerable: High DAST alert is filed without validation evidence

This fixture should produce DAST finding validation findings.

## Review Context

- Tool: OWASP ZAP full scan
- Target: staging API
- Raw alert: High SQL injection on `/api/search`
- Triage action: engineering ticket filed directly from scanner output

## Raw Scanner Output

| Finding ID | Alert Type | Endpoint | Parameter | Raw Evidence | Validation Result |
|---|---|---|---|---|---|
| `ZAP-40018-7781` | SQL Injection | `GET /api/search` | `q` | scanner says "possible SQL syntax error" | not recorded |

## Missing Validation

- No redacted request/response pair is attached.
- No safe reproduction steps were run in staging.
- The scanner used an admin test token, but the ticket does not record role, token scope, or session age.
- The scan reused a stale CSRF token from a HAR file, causing many `403` responses.
- WAF logs show the payload was blocked before reaching the application, but the ticket still claims exploitable SQL injection.
- There is no false-positive rationale, severity calibration, owner confirmation, or retest plan.

Expected findings:

- `DAST-VAL-02` because request/response context is missing.
- `DAST-VAL-03` because authorized reproduction steps are missing.
- `DAST-VAL-04` because raw scanner severity is used as final validation.
- `DAST-VAL-05` because downgrade or false-positive rationale is missing.
- `DAST-VAL-06` because auth context and session freshness are missing.
- `DAST-VAL-07` because severity is not calibrated against WAF behavior and exploitability.
- `DAST-VAL-08` because the ticket lacks owner-ready validation and retest details.

Expected handling: reproduce safely, record redacted evidence, document auth/session context, classify confirmed vs false positive, calibrate severity, and assign an owner with retest criteria.
