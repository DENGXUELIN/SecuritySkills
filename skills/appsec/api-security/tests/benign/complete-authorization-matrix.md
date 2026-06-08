# Benign: Authorization matrix covers own, other, cross-tenant, and lower-privilege cases

This fixture should avoid API authorization matrix findings because expected and actual decisions are recorded with server-side enforcement evidence.

## Review Context

- API style: REST plus GraphQL
- Resource: invoices
- Authorization model: route middleware plus service-layer ownership predicate
- Review date: `2026-06-09`

## Authorization Evidence Matrix

| Endpoint / Operation | Object / Resource | Actor / Role | Ownership / Tenant Context | Expected Decision | Actual Decision | Evidence Source | Enforcement Point | OWASP Mapping | Test Evidence | Owner / Retest |
|---|---|---|---|---|---|---|---|---|---|---|
| `GET /v1/invoices/{invoiceId}` | invoice `inv-101` | user `alice` | own object, tenant `t-100` | Allow | Allow | integration test `authz_invoice_owner_allows` | service-layer `InvoicePolicy.canRead` | API1:2023 | CI `AUTHZ-771` | N/A |
| `GET /v1/invoices/{invoiceId}` | invoice `inv-202` | user `alice` | same-tenant other user | Deny | Deny | integration test `authz_invoice_same_tenant_other_denies` | service-layer `InvoicePolicy.canRead` | API1:2023 | CI `AUTHZ-772` | N/A |
| `GET /v1/invoices/{invoiceId}` | invoice `inv-900` | user `alice` | cross-tenant `t-200` | Deny | Deny | integration test `authz_invoice_cross_tenant_denies` | tenant predicate in repository query | API1:2023 | CI `AUTHZ-773` | N/A |
| `POST /v1/invoices/{invoiceId}/refund` | refund function | support role | lower privilege than billing admin | Deny | Deny | integration test `authz_refund_support_denies` | route middleware plus service policy | API5:2023 | CI `AUTHZ-774` | N/A |
| `GraphQL invoice(id).paymentMethod` | nested invoice field | user `alice` | cross-tenant `t-200` | Deny | Deny | resolver test `graphql_payment_method_cross_tenant_denies` | resolver field guard | API1:2023 | CI `AUTHZ-775` | N/A |

## Review Notes

- Positive and negative decisions are recorded for the sensitive invoice object and refund function.
- Matrix includes own-object, same-tenant other-object, cross-tenant, lower-privilege, and GraphQL nested-field cases.
- Enforcement points are server-side middleware, service-layer policies, repository tenant predicates, and resolver guards.
- No actual customer data or tokens are included.

Expected outcome:

- Do not flag `API-AUTHZ-01` because sensitive operations are present in the matrix.
- Do not flag `API-AUTHZ-02` through `API-AUTHZ-04` because object, actor, expected decision, and actual decision are recorded.
- Do not flag `API-AUTHZ-05` because negative tests cover other-object, cross-tenant, and lower-privilege cases.
- Do not flag `API-AUTHZ-06` or `API-AUTHZ-07` because server-side REST and GraphQL enforcement points are documented.
- Do not flag `API-AUTHZ-08` because no unexpected result remains open.
