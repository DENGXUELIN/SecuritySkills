# Benign: scoped suppression with lifecycle evidence

This sample should be allowed as a narrow scanner exception because it is tied to specific evidence, scope, owner, expiration, and revalidation triggers.

## Scenario

- Scanner: Tenable
- Plugin ID: `15901`
- CVE: `CVE-2024-0001`
- Asset: `rhel-prod-17.example.internal`
- False positive root: vendor backported the security patch without changing the upstream banner
- Evidence: authenticated package manager output and vendor advisory confirm the fixed downstream package build

## Suppression ticket excerpt

```yaml
scanner: Tenable
plugin_id: "15901"
cve: CVE-2024-0001
affected_scope: "host:rhel-prod-17.example.internal package:openssl-1.1.1k-12.el8_9.4"
suppression_scope: "asset:rhel-prod-17.example.internal plugin:15901 cve:CVE-2024-0001"
evidence:
  authenticated_rescan_id: "scan-2026-06-08-1142"
  package_manager_output: "openssl-1.1.1k-12.el8_9.4 installed"
  vendor_advisory: "RHSA-2026:1442 confirms backported fix"
owner: "Vulnerability Management"
approver: "AppSec Lead"
created_date: "2026-06-08"
expiration_date: "2026-09-06"
revalidation_trigger:
  - "Tenable plugin 15901 signature update"
  - "openssl package rebuild or downgrade"
  - "host moves to internet-facing segment"
status: "active"
```

## Expected result

- Decision: `Allow scoped suppression`
- Required non-finding: do not reject this suppression as permanent scanner hiding because it has exact asset/plugin/CVE scope, authenticated evidence, named approval, a revalidation date, and concrete triggers.
- Required recommendation: retain the exception only while the package/version, asset exposure, and scanner plugin behavior remain unchanged.
