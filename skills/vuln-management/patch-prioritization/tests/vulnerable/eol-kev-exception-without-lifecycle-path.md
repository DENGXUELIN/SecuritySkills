# Vulnerable Fixture: EOL KEV Exception Without Lifecycle Path

## Scenario

A quarterly risk exception is approved for an internet-facing VPN appliance with active exploitation and no patch stream for the installed major version.

## Evidence Presented

```json
{
  "exception_id": "EXC-2026-0417",
  "cve_id": "CVE-2024-30999",
  "asset": "legacy-vpn-01",
  "product": "Legacy VPN Gateway",
  "version": "9.1.4",
  "exposure": "internet-facing",
  "business_criticality": "critical",
  "cisa_kev": true,
  "epss": 0.81,
  "patch_available": "No",
  "vendor_support": "EOL/Unsupported",
  "support_evidence": "ticket note says appliance is old; no vendor lifecycle URL attached",
  "requested_extension_days": 90,
  "business_justification": "replacement project planned next quarter",
  "compensating_controls": {
    "firewall_allowlist": ["203.0.113.0/24"],
    "tested_against_exploit_path": false,
    "coverage": "vpn-management-port only"
  },
  "migration": {
    "owner": "network-team",
    "funded_ticket": null,
    "target_version_or_replacement": null,
    "deadline": null
  },
  "approval": {
    "approver": "system owner",
    "authority_matches_original_sla": false
  },
  "retest_trigger": null
}
```

## Expected Finding

Classify this as blocked, not as a managed exception. It fails `PATCH-EOL-01`, `PATCH-EOL-02`, `PATCH-EOL-04`, `PATCH-EOL-05`, `PATCH-EOL-06`, `PATCH-EOL-07`, and `PATCH-EOL-08`: the vendor lifecycle proof is missing, no fixability path is selected, the unsupported internet-facing KEV condition remains P0 until exposure is removed, the allowlist is not tested against the exploit path, no funded migration or retirement plan exists, approval authority is insufficient, and there is no retest trigger.
