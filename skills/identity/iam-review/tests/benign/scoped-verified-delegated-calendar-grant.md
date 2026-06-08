---
case: scoped-verified-delegated-calendar-grant
expected: pass
skill: iam-review
---

# Benign Case: Scoped Verified Delegated Calendar Grant

## OAuth Grant Facts

- Application: `Internal Scheduling Assistant`.
- Client ID: `aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee`.
- Publisher: internal verified publisher with matching verified domain.
- Grant type: delegated permission; signed-in user required.
- Resource API: Microsoft Graph.
- Scopes: `Calendars.Read`, `User.Read`.
- Consent scope: assigned security group `Scheduling-Assistant-Pilots`.
- Granted by: Cloud App Administrator through admin consent workflow ticket `IAM-4821`.
- Owner and purpose: productivity engineering owner; pilot scheduling automation only.
- Assignment restriction: assignment required; no tenant-wide grant.
- Last use: successful delegated token use within 14 days by pilot users only.
- Review date: reviewed on 2026-05-30; next review due 2026-08-30.
- Audit coverage: consent, app role assignment, token usage, and credential changes are forwarded to SIEM.
- Revocation procedure: tested in staging; app loses calendar access after group removal.

## Expected Skill Behavior

The OAuth consent grant decision may be `Pass`.

The report should preserve:

- verified publisher evidence;
- delegated-vs-application classification;
- assigned group scope;
- approval ticket and owner;
- last-use and review date;
- audit coverage and revocation evidence.
