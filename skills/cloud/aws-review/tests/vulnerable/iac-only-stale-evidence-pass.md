# Vulnerable Fixture: IaC-Only Stale Evidence Marked Pass

## Scenario

The AWS CIS review marks S3 public access and CloudTrail controls as passing
because Terraform files contain secure settings. The reviewer does not collect
fresh live exports, account/region coverage, AWS Config status, or drift
evidence from the deployed environment.

## Evidence Snapshot

| Field | Value |
|---|---|
| Account | `111122223333` |
| Regions claimed | `us-east-1`, `us-west-2`, `eu-west-1` |
| CIS controls | `2.1.4`, `3.1`, `3.3` |
| Evidence basis | IaC intent only |
| Source | `terraform/security-baseline/s3.tf`, `terraform/logging/cloudtrail.tf` |
| Last file update | `2025-11-14` |
| Review date | `2026-06-30` |
| Live AWS export | Not collected |
| AWS Config | Not checked |
| CloudTrail event history | Not checked |
| Coverage limitation | No account or region export proves deployed state |
| Result assigned | Pass |

## Problem Indicators

- `AWS-EVID-01`: The control result does not separate IaC intent from live
  deployed state.
- `AWS-EVID-02`: Evidence freshness is stale relative to the review date.
- `AWS-EVID-03`: Account and region coverage are claimed but not proven.
- `AWS-EVID-04`: IaC-only evidence is treated as deployed-state proof.
- `AWS-EVID-05`: The review scores global compliance without regional exports.
- `AWS-EVID-08`: Confidence is not assigned before marking the controls Pass.

## Expected Finding

Classify as **Medium** governance risk, or **High** if the missing live evidence
covers critical logging or storage exposure controls. The controls should be
marked Not Evaluable or low-confidence until fresh live/exported state and
coverage evidence are collected.

## Required Remediation

Collect live AWS CLI/API exports or AWS Config/Security Hub evidence for each
account and region, document timestamps, coverage, limitations, drift checks,
and confidence before scoring the CIS controls.
