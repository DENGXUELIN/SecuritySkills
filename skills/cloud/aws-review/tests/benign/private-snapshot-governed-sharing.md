# Benign: Private Snapshots With Governed Sharing

## Scenario

Production snapshots exist, but public sharing is blocked and a private analytics copy has documented governance.

## Evidence

```text
aws rds describe-db-snapshot-attributes --db-snapshot-identifier prod-ledger-2026-06-01
restore:
  - 111122223333

aws ec2 describe-snapshot-attribute --snapshot-id snap-0ledgercopy --attribute createVolumePermission
createVolumePermission:
  - UserId: 111122223333

aws ec2 get-snapshot-block-public-access-state --region us-east-1
State: block-all-sharing

aws ec2 describe-image-attribute --image-id ami-0privategolden --attribute launchPermission
launchPermission:
  - UserId: 111122223333
```

## Governance Evidence

- Account `111122223333` is the approved analytics account in the same AWS Organization.
- Ticket: `SEC-7421`.
- Owner: Data Platform.
- Purpose: monthly sanitized analytics copy.
- Expiry/review date: 2026-07-31.
- Data lineage: sanitized copy job `ledger-snapshot-redaction-v4`.
- Remediation check: no `Group=all` restore, create-volume, or launch permissions found in us-east-1.

## Expected Skill Behavior

The AWS review should not report this as public snapshot exposure.

Required satisfied gates:

- `AWS-SNAP-01` records non-public RDS snapshot restore sharing.
- `AWS-SNAP-02` records explicit account-only EBS snapshot sharing.
- `AWS-SNAP-03` records `block-all-sharing` for the reviewed Region.
- `AWS-SNAP-04` records non-public AMI launch permission.
- `AWS-SNAP-05` captures sanitized lineage.
- `AWS-SNAP-06` captures owner, ticket, purpose, expiry, and approved account.
- `AWS-SNAP-07` captures account and Region coverage.
- `AWS-SNAP-08` records verification evidence.

## Correct Classification

Informational or Pass for public exposure, with a governed private-sharing note.
