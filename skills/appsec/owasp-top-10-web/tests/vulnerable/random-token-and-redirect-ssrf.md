# Vulnerable Fixture: Random Token and Redirect-Following SSRF

## Scenario

A web review finds both `Math.random()` and a URL fetch helper. The random value
is security-sensitive because it becomes a password reset token. The fetch helper
checks the first hostname but follows redirects without validating the final
destination.

## Code Snapshot

```javascript
app.post("/reset", async (req, res) => {
  const resetCode = Math.random().toString(36).slice(2);
  await resetStore.save({ userId: req.body.userId, resetCode });
  await mailer.sendResetLink(req.body.email, `https://app.example/reset/${resetCode}`);
  res.sendStatus(204);
});
```

```python
import ipaddress
import requests
from urllib.parse import urlparse

ALLOWED_HOSTS = {"images.partner.example"}

def import_avatar(url):
    parsed = urlparse(url)
    if parsed.scheme != "https" or parsed.hostname not in ALLOWED_HOSTS:
        raise ValueError("destination not allowed")

    response = requests.get(url, allow_redirects=True, timeout=3)
    return response.text
```

## Evidence Snapshot

| Field | Value |
|---|---|
| Random value purpose | Password reset token |
| Random API | `Math.random()` |
| Token controls | No CSPRNG, no length/entropy target, token appears in reset URL |
| URL source | User-controlled avatar import URL |
| First-hop validation | Scheme and host allowlist only |
| Redirect behavior | `allow_redirects=True`; no per-hop validation |
| Final destination validation | Missing DNS/IP/private-range/metadata checks after redirects |
| Response handling | Raw response body is returned to the caller |

## Problem Indicators

- `OWASP-RAND-01`: The random value protects password reset authorization.
- `OWASP-RAND-02`: A predictable PRNG generates a security-sensitive token.
- `OWASP-RAND-04`: Token entropy, uniqueness, replay, and storage controls are not evidenced.
- `OWASP-SSRF-01`: User-controlled server-side fetch follows redirects.
- `OWASP-SSRF-03`: Redirect `Location` targets are not revalidated.
- `OWASP-SSRF-04`: Final IP/private-range and DNS rebinding checks are missing.
- `OWASP-SSRF-05`: Raw fetched content is returned without redirect-chain evidence.

## Expected Findings

Classify the reset token issue under **A02: Cryptographic Failures / CWE-330**.
Classify the fetch helper under **A10: SSRF / CWE-918** because an allowed
partner URL can redirect to an internal or metadata destination.

## Required Remediation

Use a CSPRNG such as `crypto.randomBytes` or `crypto.getRandomValues` for reset
tokens, bind tokens to user/session and expiry, and avoid logging tokens. For
the fetch helper, disable redirects or validate each redirect hop and final
connect-time IP against the allowlist, blocked ranges, and metadata endpoints.
