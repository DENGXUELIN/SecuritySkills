# Benign: High DAST alert has owner-ready validation evidence

This fixture should avoid DAST finding validation findings because the alert is reproducible, calibrated, and linked to ownership evidence.

## Review Context

- Tool: OWASP ZAP full scan plus manual replay
- Target: approved staging API
- Raw alert: High reflected XSS on `/support/tickets`
- Review date: `2026-06-09`

## DAST Finding Validation Evidence

| Finding ID | Alert Type | Affected Endpoint | Parameter / Vector | Raw Evidence | Auth Context | Session Freshness | Reproduction Steps | Validation Result | FP Rationale | Severity Calibration | Owner / Ticket / Retest |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `ZAP-40012-9910` | Reflected XSS | `GET /support/tickets` | query parameter `filter` | redacted request `REQ-9910`, response snippet `RESP-9910` showing encoded payload context | support user, non-admin token scope | fresh login `AUTH-2026-0609-01`, CSRF token regenerated per replay | replay in staging with harmless marker payload and browser verification | Confirmed | N/A | raw High -> final High because authenticated support users can trigger script in same-role browser context | appsec / `APPSEC-4421` / retest after fix |
| `ZAP-40018-9922` | SQL Injection | `GET /api/search` | query parameter `q` | redacted request `REQ-9922`, WAF block log `WAF-7788` | normal user token scope | fresh login `AUTH-2026-0609-02` | replayed payload reached WAF, app logs show no database execution | False Positive | blocked before application, parameterized query verified in code review | raw High -> final Informational, track WAF noise tuning | appsec / `APPSEC-4422` / no app retest required |

## Review Notes

- Evidence keeps method, path, parameter, payload class, status, and log references while omitting credentials and personal data.
- Auth context and session freshness are recorded for authenticated findings.
- Confirmed and false-positive findings both include rationale and severity calibration.
- Confirmed finding has owner, ticket, SLA, and retest path.

Expected outcome:

- Do not flag `DAST-VAL-01` through `DAST-VAL-04` because finding identity, evidence, reproduction, and validation result are recorded.
- Do not flag `DAST-VAL-05` because false-positive rationale is recorded where applicable.
- Do not flag `DAST-VAL-06` because auth context and session freshness are recorded.
- Do not flag `DAST-VAL-07` because raw severity is calibrated to final severity.
- Do not flag `DAST-VAL-08` because confirmed work has owner, ticket, and retest criteria.
