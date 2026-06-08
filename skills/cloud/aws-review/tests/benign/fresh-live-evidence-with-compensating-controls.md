# Benign Fixture: Fresh Live Evidence With Compensating Controls

## Scenario

The AWS CIS review uses fresh live exports and continuous-control evidence to
support control scoring. The reviewer records evidence basis, coverage, limits,
compensating controls, and confidence for each control before assigning status.

## Evidence Snapshot

| Field | Value |
|---|---|
| Account | `111122223333` |
| Organization unit | `prod-payments` |
| Regions reviewed | `us-east-1`, `us-west-2`, `eu-west-1` |
| CIS control | `2.1.4 S3 Block Public Access` |
| Evidence basis | Live/exported state plus continuous control |
| Source export | `aws s3control get-public-access-block --account-id 111122223333` |
| Export timestamp | `2026-06-30T09:15:00Z` |
| AWS Config rule | `s3-account-level-public-access-blocks-periodic`, last success `2026-06-30T09:20:00Z` |
| CloudTrail data events | Enabled for production buckets, checked `2026-06-30T09:25:00Z` |
| SCP coverage | `DenyS3PublicAccessChanges`, reviewed `2026-06-01T12:00:00Z` |
| Coverage | All production accounts in OU and all enabled commercial regions |
| Known limitation | GovCloud accounts excluded and listed as out of scope |
| Status assigned | Pass |
| Confidence | High |

## Positive Controls

- `AWS-EVID-01`: Evidence basis distinguishes live export, continuous control,
  and SCP control evidence.
- `AWS-EVID-02`: Export, Config, CloudTrail, and SCP evidence include timestamps
  and freshness status.
- `AWS-EVID-03`: Account, OU, region, and resource coverage are documented.
- `AWS-EVID-04`: IaC intent is not used as the sole proof of live state.
- `AWS-EVID-05`: Excluded GovCloud scope is explicit rather than silently scored.
- `AWS-EVID-06`: SCP and AWS Config auto-remediation are documented as
  compensating controls.
- `AWS-EVID-07`: Scope limits and evidence limitations are included.
- `AWS-EVID-08`: High confidence is assigned with rationale before Pass status.

## Expected Result

Accept the Pass result for the scoped environment. Any follow-up should target
the explicitly excluded GovCloud accounts, not the reviewed production OU.
