# Benign Fixture: UI Randomness and Validated Redirect Fetch

## Scenario

A reviewer sees `Math.random()` and redirect-capable URL fetching. The random
value only controls UI animation timing, while security tokens use a CSPRNG. The
fetch helper validates the original URL and every redirect hop before connecting.

## Code Snapshot

```javascript
const animationDelayMs = Math.floor(Math.random() * 800);
setTimeout(() => animateToast(), animationDelayMs);

app.post("/reset", async (req, res) => {
  const resetCode = crypto.randomBytes(32).toString("base64url");
  await resetStore.save({
    userId: req.body.userId,
    tokenHash: await hashToken(resetCode),
    expiresAt: Date.now() + 15 * 60 * 1000,
  });
  await mailer.sendResetLink(req.body.email, `https://app.example/reset/${resetCode}`);
  res.sendStatus(204);
});
```

```python
import ipaddress
import requests
from urllib.parse import urljoin, urlparse

ALLOWED_HOSTS = {"images.partner.example"}

def validate_destination(candidate):
    parsed = urlparse(candidate)
    if parsed.scheme != "https" or parsed.hostname not in ALLOWED_HOSTS:
        raise ValueError("destination not allowed")

    for address in resolve_host(parsed.hostname):
        ip = ipaddress.ip_address(address)
        if ip.is_private or ip.is_loopback or ip.is_link_local:
            raise ValueError("blocked private destination")

def import_avatar(url):
    validate_destination(url)
    session = requests.Session()
    response = session.get(url, allow_redirects=False, timeout=3)

    redirect_chain = []
    while response.is_redirect:
        next_url = urljoin(response.url, response.headers["Location"])
        validate_destination(next_url)
        redirect_chain.append(next_url)
        if len(redirect_chain) > 3:
            raise ValueError("too many redirects")
        response = session.get(next_url, allow_redirects=False, timeout=3)

    return parse_expected_image_metadata(response.content)
```

## Evidence Snapshot

| Field | Value |
|---|---|
| Random value purpose | UI animation delay only |
| Random API | `Math.random()` for UI; `crypto.randomBytes(32)` for reset token |
| Token controls | Hash at rest, 32 random bytes, 15-minute expiry |
| URL source | User-provided avatar URL |
| First-hop validation | HTTPS and exact host allowlist |
| Redirect behavior | Redirects handled manually with a depth limit |
| Final destination validation | Each hop checks scheme, host, DNS result, private, loopback, and link-local ranges |
| Response handling | Parser extracts expected image metadata instead of returning raw internal content |

## Positive Controls

- `OWASP-RAND-01`: `Math.random()` does not feed a security-sensitive sink.
- `OWASP-RAND-02`: Reset tokens use a CSPRNG.
- `OWASP-RAND-03`: UI animation randomness is documented as a non-finding.
- `OWASP-RAND-04`: Security token length, hashing, and expiry are evidenced.
- `OWASP-SSRF-01`: Redirect behavior and maximum depth are documented.
- `OWASP-SSRF-02`: Initial URL validation uses exact scheme and host allowlist.
- `OWASP-SSRF-03`: Each redirect `Location` is revalidated.
- `OWASP-SSRF-04`: DNS/IP private-range checks happen for every hop.
- `OWASP-SSRF-05`: Redirect chain is bounded and raw response proxying is avoided.

## Expected Result

Do not report A02 for the UI animation delay. Do not report A10 merely because
the feature imports an external avatar URL; only report if an actual redirect,
DNS, IP-range, or raw-response control is missing.
