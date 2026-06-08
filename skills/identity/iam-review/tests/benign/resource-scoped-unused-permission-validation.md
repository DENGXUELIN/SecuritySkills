# Benign Fixture: Resource-Scoped Unused Permission Validation

## Scenario

An IAM role has broad S3 read access across two buckets. Action-level usage shows
`s3:GetObject` was used, but resource-scoped evidence proves the role only reads
the billing exports bucket and never reads the legacy invoices bucket.

## Evidence Snapshot

| Field | Value |
|---|---|
| Principal | `arn:aws:iam::111122223333:role/prod-billing-processor` |
| Policy | `BillingProcessorReadPolicy` |
| Permission | `s3:GetObject` |
| Resource scope under review | `arn:aws:s3:::legacy-invoices-prod/*` |
| Still-required scope | `arn:aws:s3:::billing-exports-prod/*` |
| Usage data source | CloudTrail data events and S3 server access logs |
| Observation window | `2026-01-01` to `2026-06-30` |
| Last used for reviewed scope | No reads found in 181 days |
| Provider limitation handled | Action-level use kept separate from resource-level use |
| Secondary evidence | Batch jobs `BILL-DAILY-*`, tickets `FIN-1831`, app logs `billing-prod` |
| Business owner | `Billing Platform Team`, confirmed `2026-06-27` |
| Decision | Remove only `legacy-invoices-prod/*`, keep `billing-exports-prod/*` |
| Confidence | High |
| Rollback | Versioned policy rollback `CHG-18391`, monitor denied S3 reads for 14 days |

## Positive Controls

- `IAM-UPERM-01`: The finding identifies principal, policy, action, and resource
  scope.
- `IAM-UPERM-02`: The evidence source supports the specific S3 resource scope.
- `IAM-UPERM-03`: The observation window covers monthly, quarterly, and
  semiannual billing jobs.
- `IAM-UPERM-04`: Action-level usage is not treated as proof that all resources
  are used.
- `IAM-UPERM-05`: Secondary CloudTrail, S3, job, ticket, and app evidence agree.
- `IAM-UPERM-06`: The business owner confirmed the legacy bucket is retired.
- `IAM-UPERM-07`: Trust policy, permission boundary, and chained role paths were
  checked for effective access.
- `IAM-UPERM-08`: Downscope confidence, staged deploy, denied-read monitoring,
  and rollback evidence are documented.

## Expected Result

Recommend a targeted downscope of the unused resource-level permission. Do not
remove the still-used `s3:GetObject` permission on the billing exports bucket.
