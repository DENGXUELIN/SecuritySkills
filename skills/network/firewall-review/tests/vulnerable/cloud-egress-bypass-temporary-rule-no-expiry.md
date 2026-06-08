# Vulnerable Fixture: Cloud Egress Bypass and Temporary Rule Without Expiry

## Scenario

A production workload subnet is documented as "HTTPS through approved proxy
only." The Terraform security group keeps a broad outbound rule, the subnet has
a direct NAT route, and an incident bridge temporary rule remains active with no
expiry.

## Evidence Snapshot

| Field | Value |
|---|---|
| Workload | `prod-api-subnet-a` |
| Declared egress policy | `tcp/443 to approved proxy only` |
| Security group egress | `0.0.0.0/0 tcp/443 allow` |
| Route table | `0.0.0.0/0 -> nat-gateway-public-a` |
| Proxy route enforcement | Not required by route table or endpoint policy |
| NACL / NSG evidence | Default outbound allow |
| Temporary rule | `TEMP-INC-4412 allow tcp any destination any` |
| Temporary rule expiry | `null` |
| Owner / approver | Missing owner; approver listed as "incident bridge" |
| Runtime logs | Flow logs show direct connections to unapproved SaaS IP ranges |
| Effective-rule export | Only Terraform reviewed; no cloud effective-rule export |
| Review coverage | Single subnet checked, but report generalizes to all production |

## Problem Indicators

- `FW-EGRESS-01`: Declared policy and effective cloud rules disagree.
- `FW-EGRESS-02`: NAT route bypasses the approved proxy path.
- `FW-EGRESS-03`: Destination allowlist is missing for broad outbound HTTPS.
- `FW-EGRESS-04`: Stateful return traffic is used to justify new outbound sessions.
- `FW-EGRESS-05`: Temporary egress rule has no expiry, owner, or removal evidence.
- `FW-EGRESS-06`: Effective-rule evidence is partial and stale.
- `FW-EGRESS-07`: Runtime flow logs show unapproved direct egress.
- `FW-EGRESS-08`: Broad egress is accepted without risk owner or next review.

## Expected Finding

Classify as **High** because the workload can initiate direct outbound internet
traffic despite a proxy-only policy claim. The temporary rule should be treated
as an active exception requiring owner assignment, expiry, and removal evidence.

## Required Remediation

Replace broad outbound rules with destination-scoped egress, force routes
through the approved proxy or egress firewall, remove or expire the temporary
rule, assign an owner and approver, and verify runtime flow logs after the
change.
