---
name: benign-native-addon-provenance-sandbox
expected: pass
---

# Benign install-script fixture

## Lockfile entry

```
package: native-addon
version: 1.8.3
release_age: 63 days
maintainer_change: none in last 18 months
postinstall: node-gyp rebuild
```

## Evidence

| Field | Value |
|---|---|
| Script purpose | Native compilation for platform bindings |
| Network access | Blocked in CI |
| Environment secret access | None observed |
| Provenance | npm provenance and Sigstore bundle verified |
| Sandbox controls | CI egress disabled, registry allow-list enabled |

## Expected review result

Pass the takeover check. The install script is expected native-build behavior, publisher history is stable, provenance is verified, and CI sandbox controls limit network and secret exposure.
