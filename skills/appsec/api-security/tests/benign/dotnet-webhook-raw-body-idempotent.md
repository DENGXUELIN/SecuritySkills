# Benign Fixture: .NET Webhook Raw Body and Idempotency Evidence

## Scenario

An ASP.NET Core webhook receiver verifies GitHub webhooks over the exact raw
request body before JSON parsing. It stores `X-GitHub-Delivery` before side
effects and verifies repository, event type, environment, and secret version.

## Evidence Snapshot

| Field | Value |
|---|---|
| Endpoint | `POST /webhooks/github` |
| Framework | ASP.NET Core controller, .NET 8 |
| Raw-body capture | `Request.EnableBuffering()` and raw UTF-8 read before deserialization |
| Signature header | `X-Hub-Signature-256` |
| Delivery header | `X-GitHub-Delivery` |
| Constant-time compare | `CryptographicOperations.FixedTimeEquals` |
| Replay control | Delivery ID insert happens before side effects |
| Event allowlist | `push`, `pull_request`, `workflow_run` only |
| Binding | Repository owner/name and installation ID match configured tenant |
| Environment scope | Production endpoint accepts only production secret version |
| Rotation | Old secret accepted for 24 hours with versioned audit entry |
| Retry behavior | Duplicate delivery returns 200 without duplicate side effects |
| Audit log | Signature result, delivery ID, event type, repository, and decision |

## Positive Controls

- `DOTNET-WH-01`: Raw body is verified before parsing.
- `DOTNET-WH-02`: Signature and timestamp policy are enforced with constant-time comparison.
- `DOTNET-WH-03`: Delivery ID storage enforces idempotency before side effects.
- `DOTNET-WH-04`: Event types are allowlisted.
- `DOTNET-WH-05`: Repository and installation are bound to local tenant config.
- `DOTNET-WH-06`: Secret source and rotation window are environment-scoped.
- `DOTNET-WH-07`: Duplicate, stale, invalid, and wrong-repository deliveries are tested.
- `DOTNET-WH-08`: Review evidence captures raw-body handling, header mapping,
  replay decision, side-effect boundary, and audit logging.

## Expected Result

Do not flag the receiver as missing webhook authenticity or replay controls. Any
remaining finding should focus on provider-specific business logic, not the
receiver evidence gates.
