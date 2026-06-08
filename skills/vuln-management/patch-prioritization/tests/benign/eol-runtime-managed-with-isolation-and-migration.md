# Benign Fixture: EOL Runtime Managed With Isolation and Migration

## Scenario

A legacy application depends on an EOL runtime with no in-place hotfix, but the finding is handled through lifecycle evidence, tested isolation, an approved replacement plan, and a dated retest trigger.

## Evidence Presented

```json
{
  "exception_id": "EXC-2026-0521",
  "cve_id": "CVE-2023-41888",
  "asset_group": "claims-batch-workers",
  "product": "Runtime 2.7",
  "versions": ["2.7.18"],
  "affected_assets": 12,
  "mapped_assets": 12,
  "exposure": "internal-only",
  "business_criticality": "high",
  "cisa_kev": false,
  "epss": 0.027,
  "patch_available": "Workaround Only",
  "vendor_support": "EOL/Unsupported",
  "lifecycle_evidence": {
    "source": "vendor lifecycle advisory and package repository metadata",
    "retrieved_at": "2026-05-21",
    "end_of_support": "2025-12-31"
  },
  "patch_path": "Retire/replace",
  "interim_control": {
    "type": "network isolation plus feature disablement",
    "exploit_vector_mapping": "blocks inbound deserialization endpoint and disables legacy parser",
    "tested_at": "2026-05-22",
    "test_result": "known exploit request denied and parser absent from runtime config",
    "coverage": "12 of 12 assets"
  },
  "migration": {
    "owner": "claims-platform",
    "funded_ticket": "CHG-92841",
    "target_version_or_replacement": "Runtime 3.12 container image",
    "deadline": "2026-06-28"
  },
  "approval": {
    "approver": "security director",
    "authority_matches_original_sla": true,
    "expires": "2026-06-30"
  },
  "retest_trigger": "rescan after CHG-92841 deployment or by 2026-06-30, whichever comes first"
}
```

## Expected Finding

Accept this as a managed lifecycle exception with residual risk documented. It satisfies `PATCH-EOL-01` through `PATCH-EOL-08`: lifecycle evidence is current, the fixability decision is retire/replace, all assets are mapped, exploitation and exposure are reflected, interim controls are tested against the exploit path, a funded migration deadline exists within the original SLA exception window, approval authority matches the tier, and the retest trigger is explicit.
