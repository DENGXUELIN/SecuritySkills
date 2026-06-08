# Vulnerable Fixture: .NET Webhook Parses Before Signature

## Scenario

An ASP.NET Core Minimal API endpoint accepts Stripe-style webhook callbacks. The
handler calls `ReadFromJsonAsync` before verifying `Stripe-Signature`, then
applies side effects without storing the event ID first.

## Evidence Snapshot

| Field | Value |
|---|---|
| Endpoint | `POST /webhooks/stripe` |
| Framework | ASP.NET Core Minimal API, .NET 8 |
| Body handling | `request.ReadFromJsonAsync<StripeEvent>()` before signature verification |
| Signature header | `Stripe-Signature` checked for presence only |
| Timestamp tolerance | Not enforced |
| Constant-time compare | Not used |
| Event allowlist | Missing |
| Idempotency | No processed event table before side effects |
| Tenant binding | Uses event customer ID without local account binding |
| Secret rotation | Single unversioned secret from shared config |
| Retry behavior | Duplicate deliveries trigger duplicate invoice credit |

## Problem Indicators

- `DOTNET-WH-01`: JSON is parsed before raw-body signature verification.
- `DOTNET-WH-02`: Signature timestamp and constant-time comparison are missing.
- `DOTNET-WH-03`: Event ID is not stored before side effects.
- `DOTNET-WH-04`: Unknown event types are accepted.
- `DOTNET-WH-05`: Tenant/account binding is not checked.
- `DOTNET-WH-06`: Secret rotation is not environment-scoped or bounded.
- `DOTNET-WH-07`: Duplicate provider retries are not tested.
- `DOTNET-WH-08`: Evidence omits raw-body capture and side-effect boundary.

## Expected Finding

Classify as **High** if webhook side effects affect billing, provisioning, or
authorization state. The handler is vulnerable to signature-bypass mistakes,
replay, and duplicate side effects.

## Required Remediation

Capture the raw body before parsing, verify the provider signature and timestamp,
store delivery/event IDs before side effects, enforce event allowlists and tenant
binding, and test duplicate/stale/invalid deliveries.
