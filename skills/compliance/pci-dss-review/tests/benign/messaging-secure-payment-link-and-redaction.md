# Benign: secure payment link workflow with verified PAN blocking

## Scenario

The assessor is reviewing Req 4.2.2 for customer support channels. Customers can request payment help through chat and tickets, but support systems route payment collection to a PCI-scoped payment page and block recoverable PAN from end-user messaging storage.

## Evidence

| Field | Value |
|---|---|
| Channel inventory | Email, chat, support portal, ticket comments, attachments, transcript archive, search index, exports, and backups documented |
| Approved workflow | Agents send a short-lived secure payment link hosted in the CDE; support channels are not approved to receive PAN |
| DLP / prevention | Tests block full PAN, spaced PAN, attachment text, OCR screenshot PAN, and copy/paste in chat and tickets |
| Token evidence | Stored references are payment-link IDs and non-PAN tokens with documented format and no reversible PAN in support tooling |
| Storage / archive | Raw transcript, archive, search index, analytics export, and backup samples show redacted placeholders only |
| Cryptography | Payment page uses current TLS and PAN is stored only in the PCI-scoped vault with documented key management |
| Scope decision | Support platform classified as connected-to/security-impacting for workflow enforcement; payment vault remains CDE |
| Cleanup workflow | Quarterly PAN-negative sampling and PAN-detection deletion runbook have ticket evidence and retest dates |

## Expected Review Outcome

- Req 4.2.2 can be considered `In Place` for messaging channels if the sampling period and scope evidence are current.
- `PCI-PAN-MSG-01` through `PCI-PAN-MSG-08` pass with assessor-verifiable evidence.
- The benign decision depends on verified prevention, token format, raw-storage checks, and payment-link routing, not policy text alone.
