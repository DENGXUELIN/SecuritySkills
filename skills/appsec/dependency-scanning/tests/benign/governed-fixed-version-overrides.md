# Benign: Governed fixed-version overrides and development-only replacements

This fixture should avoid false positives where override controls are documented, reflected in lockfiles, and scoped safely.

## npm package.json

```json
{
  "dependencies": {
    "webpack": "5.91.0"
  },
  "overrides": {
    "braces": "3.0.3"
  }
}
```

## package-lock excerpt

```json
{
  "packages": {
    "node_modules/braces": {
      "version": "3.0.3",
      "resolved": "https://registry.npmjs.org/braces/-/braces-3.0.3.tgz",
      "integrity": "sha512-example"
    }
  }
}
```

Expected outcome: treat the `braces` override as a governed mitigation, not a finding, when the advisory fixed version is `3.0.3`, the package remains on the same trusted registry, and the lockfile reflects the resolved artifact.

## Go development-only replacement

```go
module example.com/orders

require github.com/acme/shared v1.4.2

// Used only by local integration tests; release workflow checks that no replace directives remain.
replace github.com/acme/shared => ../shared
```

Governance evidence:

- Owner: platform security
- Reason: local integration-test workspace
- Production release check: CI step `go list -m -json all` fails release builds when `Replace` is non-null
- SBOM evidence: release SBOM records `github.com/acme/shared v1.4.2` from the public module proxy
- Review trigger: remove when shared test harness publishes v1.4.3

Expected outcome: monitor or document the local replacement, but do not classify it as a production finding when release evidence proves it is excluded from production artifacts.

## Rust pinned patch

```toml
[dependencies]
ring = "0.17"

[patch.crates-io]
ring = { git = "https://github.com/org-reviewed/ring", rev = "7f3a0d9b6e1f2c3a4b5c6d7e8f90123456789abc" }
```

Governance evidence:

- Owner: crypto platform lead
- Reason: temporary FIPS validation patch before upstream release
- Review date: 2026-06-01
- Expiry: remove after upstream `ring` release includes patch or by 2026-07-15
- Lockfile evidence: `Cargo.lock` records the exact git revision
- Scanner/SBOM evidence: SBOM component includes the replacement URL and commit

Expected outcome: classify as governed/monitor, not a high-risk unpinned fork, because the source is reviewed, pinned to an immutable revision, reflected in the lockfile/SBOM, and time-bounded.
