# Vulnerable: Public Backup and Image Artifacts

## Scenario

The live database and EC2 fleet appear private, but backup artifacts are publicly shareable.

## Evidence

```text
aws rds describe-db-snapshot-attributes --db-snapshot-identifier prod-orders-2026-06-01
restore:
  - all

aws ec2 describe-snapshot-attribute --snapshot-id snap-0prodorders --attribute createVolumePermission
createVolumePermission:
  - Group: all

aws ec2 get-snapshot-block-public-access-state --region us-east-1
State: block-new-sharing

aws ec2 describe-image-attribute --image-id ami-0prodweb --attribute launchPermission
launchPermission:
  - Group: all
```

## Live Resource Context

```hcl
resource "aws_db_instance" "orders" {
  identifier            = "prod-orders"
  publicly_accessible   = false
  storage_encrypted     = true
  backup_retention_period = 7
}

resource "aws_ebs_encryption_by_default" "enabled" {
  enabled = true
}
```

## Expected Skill Behavior

The AWS review should not pass storage exposure based only on the live RDS and EBS configuration.

Required findings:

- `AWS-SNAP-01` fails because the RDS manual snapshot restore attribute is public.
- `AWS-SNAP-02` fails because the EBS snapshot grants `Group=all`.
- `AWS-SNAP-03` warns that `block-new-sharing` does not prove already-public snapshots are private.
- `AWS-SNAP-04` fails because the production AMI has public launch permission.
- `AWS-SNAP-05` should require production data lineage and sensitivity evidence.
- `AWS-SNAP-06` should require sharing owner, business purpose, ticket, expiry, and revocation evidence.
- `AWS-SNAP-07` should record Region and account coverage.
- `AWS-SNAP-08` should keep the finding open until private attributes and guardrails are reverified.

## Correct Classification

High or Critical depending on confirmed data sensitivity and production lineage.
