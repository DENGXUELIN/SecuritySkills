# Benign: verified registry module with lock evidence

## Terraform

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
}
```

## Evidence

| Field | Value |
|-------|-------|
| module_source | Terraform public registry `terraform-aws-modules/vpc/aws` |
| immutability | explicit registry version `5.8.1` |
| registry_namespace_ownership | verified organization namespace |
| lock_checksum_evidence | `.terraform.lock.hcl` committed for providers; module digest recorded in CI artifact metadata |
| mirror_provenance | not applicable |
| plan_apply_source_parity | plan and apply both use registry version `5.8.1` from the same dependency cache |
| drift_signal | no namespace, DNS, or backend change observed |

## Expected Result

The skill should not flag the module solely because it is remote or public. The dependency is version-pinned, ownership is verified, lock/provenance evidence exists, and the reviewed plan uses the same module source as apply.
