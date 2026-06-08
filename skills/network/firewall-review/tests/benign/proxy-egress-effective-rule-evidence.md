# Benign Fixture: Proxy Egress Effective-Rule Evidence

## Scenario

A production workload uses outbound HTTPS through an approved proxy. The review
collects effective cloud rules, route/NAT evidence, destination allowlists,
runtime logs, and temporary-rule lifecycle evidence before downgrading broad
egress concerns.

## Evidence Snapshot

| Field | Value |
|---|---|
| Workload | `prod-api-subnet-a` |
| Declared egress policy | `tcp/443 to approved proxy endpoint only` |
| Security group egress | `tcp/443 -> sg-approved-proxy` |
| Route table | `0.0.0.0/0 -> egress-firewall-vpc-endpoint` |
| NAT / internet gateway path | No direct NAT or internet gateway route from workload subnet |
| NACL / NSG evidence | Outbound permits only proxy and internal resolver destinations |
| Destination allowlist | Proxy FQDN/IP, DNS resolvers, package mirror, and payment API ranges with owners |
| Temporary rule | `TEMP-INC-4412` removed after incident bridge |
| Temporary rule expiry | `2026-06-02T18:00:00Z`; removal ticket `CHG-5520` closed |
| Owner / approver | Network owner and incident commander documented |
| Runtime logs | Flow logs and proxy logs show no direct internet egress during the review window |
| Effective-rule export | Cloud effective rules exported for all production accounts and regions |
| Review coverage | All production subnets, security groups, NACLs, and egress firewall policies at `2026-06-05T12:00:00Z` |

## Positive Controls

- `FW-EGRESS-01`: Effective rules match the declared proxy-only egress policy.
- `FW-EGRESS-02`: Route and NAT evidence proves direct internet bypass is absent.
- `FW-EGRESS-03`: Destination allowlist has owners and business purposes.
- `FW-EGRESS-04`: Return traffic and outbound initiation are distinguished.
- `FW-EGRESS-05`: Temporary rule has expiry, owner, approval, and removal evidence.
- `FW-EGRESS-06`: Effective-rule export covers accounts, regions, subnets, and workloads.
- `FW-EGRESS-07`: Runtime logs confirm observed egress follows the approved path.
- `FW-EGRESS-08`: Any remaining exception has owner, next review date, and risk decision.

## Expected Result

Do not flag the proxy-only egress design as unrestricted outbound access. Any
remaining finding should focus on narrower hygiene gaps, not broad egress or
temporary-rule lifecycle failure.
