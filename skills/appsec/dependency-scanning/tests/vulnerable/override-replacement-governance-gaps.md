# Vulnerable: Ungoverned dependency override and replacement rewrites

This fixture should produce override/replacement governance findings.

## npm package.json

```json
{
  "dependencies": {
    "lodash": "^4.17.21",
    "minimist": "^1.2.8"
  },
  "overrides": {
    "lodash": "github:unknown-user/lodash#main",
    "**/minimist": "0.0.8"
  }
}
```

Expected findings:

- `DEP-OVERRIDE-02` because the `minimist` resolution forces a vulnerable downgrade below known fixed lines.
- `DEP-OVERRIDE-03` because `lodash` is redirected from the public registry to an unreviewed git source on a mutable `main` branch.
- `DEP-OVERRIDE-04` if the lockfile or SBOM does not show the final git artifact and downgraded minimist package.

## Go go.mod

```go
module example.com/payments

require github.com/acme/auth v1.8.4

replace github.com/acme/auth => ../auth
replace github.com/acme/payments => github.com/fork/payments v0.0.0-20260601000000-deadbeef
```

Expected findings:

- `DEP-OVERRIDE-03` for a forked replacement without owner/provenance review.
- `DEP-OVERRIDE-06` if the local `../auth` replacement is present in production or release artifact build inputs.

## Rust Cargo.toml

```toml
[dependencies]
ring = "0.17"

[patch.crates-io]
ring = { git = "https://github.com/example/ring", branch = "main" }
```

Expected findings:

- `DEP-OVERRIDE-03` because the trusted crates.io package is shadowed by a git source.
- `DEP-OVERRIDE-05` if there is no removal plan, upstream tracking issue, or re-evaluation trigger.

## Governance Evidence

- Owner approval: absent
- Security rationale: "temporary build fix"
- Review date: absent
- Expiry/review trigger: absent
- Lockfile/SBOM evidence: unavailable
- Scanner output: covers package names only, not resolved replacement artifacts

Expected outcome: classify as supply-chain findings, not as ordinary safe transitive-dependency mitigations.
