# Benign: Rotation validation proves consumer adoption and old credential revocation

This fixture should avoid rotation validation findings because it records event, consumer, revocation, test, and monitoring evidence without exposing secret values.

## Review Context

- Secret type: database credential
- Store: HashiCorp Vault dynamic credential path `database/creds/orders-api`
- Rotation method: lease renewal disabled, new lease issued, old lease revoked
- Rotation event: `CHG-2026-0609-112`
- Review date: `2026-06-09`

## Rotation Validation Evidence

| Secret Type / Store | Secret Version / Alias | Rotation Event | Consumers | Consumer Update Status | Old Credential Revoked | Old Credential Test | New Credential Test | Monitoring Evidence | Rollback Window | Validation Confidence | Owner / Follow-up |
|---|---|---|---|---|---|---|---|---|---|---|---|
| DB credential / Vault | old lease `lease-7741`, new lease `lease-8814` | `CHG-2026-0609-112` at `2026-06-09T01:00:00Z` | `orders-api`, `orders-worker`, `report-cron` | all pods restarted and fetched `lease-8814` | Yes, revoke log `VAULT-AUDIT-9912` at `2026-06-09T01:20:00Z` | Denied, `AUTH-TEST-OLD-334` | Accepted, `AUTH-TEST-NEW-335` | DB auth logs `DBAUTH-771`, error dashboard `MON-882` | 20 minutes, closed by platform owner | High, all consumers and tests recorded | platform owner, next review `2026-07-09` |

## Review Notes

- The table records secret type/store, old and new version identifiers, rotation event, consumers, and consumer update status.
- The old credential revocation has a vault audit reference and a denied authentication test.
- The new credential has a successful consumer test.
- Monitoring includes downstream database authentication logs and service error dashboards.
- No actual secret value, password, token, or key material is present.

Expected outcome:

- Do not flag `SEC-ROT-01` or `SEC-ROT-02` because event and version metadata are present.
- Do not flag `SEC-ROT-03` because all consumers are listed and refreshed.
- Do not flag `SEC-ROT-04` or `SEC-ROT-05` because the old credential was revoked and denied.
- Do not flag `SEC-ROT-06` or `SEC-ROT-07` because new credential function and monitoring evidence are recorded.
- Do not flag `SEC-ROT-08` because the owner, rollback closure, and follow-up are documented.
