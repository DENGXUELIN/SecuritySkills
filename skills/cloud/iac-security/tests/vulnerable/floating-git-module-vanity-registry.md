# Vulnerable: floating module source and unverified private registry

## Terraform

```hcl
module "network" {
  source = "git::https://github.com/example/terraform-network.git?ref=main"
}

module "payments" {
  source  = "registry.internal.example.com/payments/vpc/aws"
  version = "1.4.0"
}
```

## Evidence

| Field | Value |
|-------|-------|
| module_source | Git branch `main`; private registry `registry.internal.example.com` |
| immutability | missing for Git source; registry artifact digest not recorded |
| registry_namespace_ownership | not verified after DNS ownership transfer |
| lock_checksum_evidence | provider lock exists, module checksum absent |
| mirror_provenance | not documented |
| plan_apply_source_parity | CI plan used cached module; production apply resolves live branch/registry |
| drift_signal | registry DNS target changed since last deployment |

## Expected Result

The skill should flag this as a supply chain integrity finding. A force-pushed Git branch or changed vanity registry backend can alter infrastructure behavior without a reviewed IaC diff.

## Required Mitigation

Pin Git modules to commit SHAs or protected immutable release tags, verify private registry ownership, record module digests/provenance, and require CI plan and production apply to use the same source and digest.
