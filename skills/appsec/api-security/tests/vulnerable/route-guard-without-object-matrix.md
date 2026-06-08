# Vulnerable: Route guard exists but object authorization matrix is missing

This fixture should produce API authorization matrix findings for API1/API5 review.

## Review Context

- API style: REST plus GraphQL
- Resource: invoices
- Authorization model: route-level `requiresRole("USER")`
- Review conclusion: "authorization is present because all invoice routes require authentication"

## Missing Matrix Evidence

| Endpoint / Operation | Claimed Control | Gap |
|---|---|---|
| `GET /v1/invoices/{invoiceId}` | `requiresRole("USER")` | no own-object, same-tenant other-object, or cross-tenant negative test |
| `POST /v1/invoices/{invoiceId}/refund` | `requiresRole("ADMIN")` | no lower-privilege or org-scope test |
| `GraphQL invoice(id)` | authenticated resolver | nested `paymentMethod` field has no field-level authorization evidence |

## Bad Outcome

- User `alice` from tenant `t-100` can fetch invoice `inv-900` owned by tenant `t-200`.
- A lower-privilege support role can call the refund endpoint when the UI hides the button but the server does not enforce function authorization.
- The GraphQL resolver checks authentication once, then returns nested invoice fields without checking object ownership.
- The review records no expected vs actual decision and no owner/retest for the unexpected allow.

Expected findings:

- `API-AUTHZ-01` because sensitive operations are missing from the matrix.
- `API-AUTHZ-02` because ownership and tenant context are missing.
- `API-AUTHZ-04` because expected and actual decisions are not recorded.
- `API-AUTHZ-05` because other-object, cross-tenant, anonymous, and lower-privilege negative tests are missing.
- `API-AUTHZ-06` because enforcement is implied by UI/client or route-level role checks only.
- `API-AUTHZ-07` because GraphQL nested field authorization is not evidenced.
- `API-AUTHZ-08` because unexpected allows lack owner, ticket, and retest.

Expected handling: build an authorization matrix, add server-side ownership and function-level checks, test denied cases, and record retest evidence.
