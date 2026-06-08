# Vulnerable: Segmentation review accepts diagrams without path validation evidence

This fixture should produce segmentation path validation findings.

## Review Context

- Environment: hybrid cloud with hub-and-spoke VPCs
- Zones: user, DMZ, app, data, management, PCI CDE
- Evidence provided: architecture diagram, firewall export, route-table screenshot
- Review conclusion: "segmentation validated"

## Missing Path Evidence

| Claimed Boundary | Missing Evidence |
|---|---|
| User to PCI CDE | no source asset, destination asset, protocol, expected result, or denied-path test |
| DMZ to Data | diagram shows firewall, but no test from DMZ host to database port |
| App to Data | required `tcp/5432` allowed path is not tested after a firewall cleanup |
| Workload to Management | no test for pod-to-bastion or workload-to-metadata paths |
| Hub to Spoke | route table screenshot does not prove transit gateway policies block lateral paths |

## Bad Evidence Example

The report includes:

```text
Segmentation is in place because the network diagram separates app, data, and management zones.
Firewall rules appear restrictive.
No active path test was performed due to time constraints.
```

No command output, flow-log ID, packet capture, policy simulator result, timestamp, tester, or confidence rating is recorded. One later change accidentally blocks `app-01 -> db-01 tcp/5432`, while another leaves `user-vdi -> cde-db tcp/1433` open through a peering route.

Expected findings:

- `SEG-PATH-01` because source/destination assets are missing.
- `SEG-PATH-02` because protocol, port, and direction are missing.
- `SEG-PATH-03` because expected and actual results are not recorded.
- `SEG-PATH-04` because evidence relies only on diagrams and policy review.
- `SEG-PATH-05` because high-risk denied paths are not sampled.
- `SEG-PATH-06` because business-critical allowed paths are not tested.
- `SEG-PATH-07` because timestamp, tester, output, and confidence are missing.
- `SEG-PATH-08` because unexpected open/broken paths lack owner and retest.

Expected handling: mark segmentation validation incomplete, create a representative path test plan, test high-risk denied paths and critical allowed paths, record evidence, and retest any unexpected results.
