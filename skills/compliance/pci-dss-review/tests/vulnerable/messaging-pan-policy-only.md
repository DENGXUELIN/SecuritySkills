# Vulnerable: policy-only PAN handling in support messaging

## Scenario

The assessor is reviewing Req 4.2.2 for a merchant that says support tooling is outside the CDE. The organization has a no-PAN policy for end-user messages and email uses TLS, but customers can still paste or attach card numbers in support tickets.

## Evidence

| Field | Value |
|---|---|
| Channel inventory | Email and support portal listed; chat transcript archive, attachment OCR, eDiscovery export, and ticket backup not listed |
| User entry path | Ticket body and attachment upload accept `4111111111111111` and screenshots containing PAN |
| Policy | "Customers must not send card numbers through support" |
| DLP / prevention | Monitor-only for ticket body; no attachment or screenshot inspection |
| Transport / encryption | Email TLS to provider; no content encryption or customer-side secure message vault |
| Storage / archive | Raw ticket body and attachments retained for seven years; searchable by support admins and analytics export |
| Scope decision | Marked out of scope because "support tickets are not payment systems" |
| Cleanup workflow | PAN alert creates a low-priority queue item; no deletion SLA or backup purge evidence |

## Expected Review Outcome

- Req 4.2.2 is `Requirement Not in Place` or `Not Tested`, not `In Place`.
- `PCI-PAN-MSG-01`, `PCI-PAN-MSG-03`, `PCI-PAN-MSG-05`, `PCI-PAN-MSG-06`, and `PCI-PAN-MSG-08` fail.
- Transport TLS and a no-PAN policy do not prove strong cryptography, prevention, retention control, or scope exclusion.
- Remediation should require channel inventory, DLP blocking or secure payment-link routing, raw storage/archive cleanup, and updated PCI scope rationale.
