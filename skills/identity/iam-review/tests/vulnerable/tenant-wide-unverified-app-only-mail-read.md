---
case: tenant-wide-unverified-app-only-mail-read
expected: fail
skill: iam-review
---

# Vulnerable Case: Tenant-Wide Unverified App-Only Mail Grant

## OAuth Grant Facts

- Application: `Invoice Sync Pro`.
- Client ID: `11111111-2222-3333-4444-555555555555`.
- Publisher: unverified external publisher; verified domain is absent.
- Grant type: application permission, no signed-in user required.
- Resource API: Microsoft Graph.
- App roles: `Mail.Read`, `Files.Read.All`, `offline_access`.
- Consent scope: tenant-wide admin consent for all users.
- Granted by: global admin account during an incident bridge; no ticket or business owner recorded.
- Assignment restriction: app assignment not required; any tenant mailbox is in scope.
- Last use: active token use in the last 24 hours; no reviewed access owner.
- Audit coverage: consent creation logged, but app token use is not forwarded to SIEM.
- Revocation test: not performed; stale-grant decision missing.

## Expected Skill Behavior

The OAuth consent grant decision should be `Fail`.

The report should raise a Critical or High finding because:

- the grant is tenant-wide and app-only;
- high-impact mail and file permissions are present;
- publisher trust is not verified;
- owner, business purpose, and approval evidence are missing;
- assignment restriction is absent;
- usage and audit coverage are insufficient for incident response.

The grant should not be treated as a normal service-account inventory item without the OAuth consent evidence fields.
