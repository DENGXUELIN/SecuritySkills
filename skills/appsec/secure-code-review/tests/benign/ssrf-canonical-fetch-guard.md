---
name: ssrf-canonical-fetch-guard
expected: benign
skill: secure-code-review
---

# Secure Code Review Fixture: Canonical SSRF Fetch Guard

Use this fixture to verify that `secure-code-review` recognizes a complete SSRF control path and does not report a false positive when validation is tied to the final connected destination.

## Review Scope

File under review: `services/preview/safe_fetch.go`

```go
type FetchGuard struct {
    resolver Resolver
    allowedHosts map[string]bool
}

func (g FetchGuard) Fetch(ctx context.Context, raw string) (*http.Response, error) {
    canonical, err := ParseCanonicalHTTPSURL(raw)
    if err != nil {
        return nil, err
    }
    if !g.allowedHosts[canonical.Hostname()] {
        return nil, ErrHostNotAllowed
    }

    client := &http.Client{
        Timeout: 3 * time.Second,
        CheckRedirect: func(req *http.Request, via []*http.Request) error {
            next := CanonicalFromRequest(req)
            if next.Scheme != "https" || !g.allowedHosts[next.Hostname()] {
                return ErrRedirectBlocked
            }
            ips, err := g.resolver.LookupIPAddr(req.Context(), next.Hostname())
            if err != nil || HasDeniedAddress(ips) {
                return ErrRedirectBlocked
            }
            req = PinResolvedDestination(req, ips)
            return nil
        },
    }

    ips, err := g.resolver.LookupIPAddr(ctx, canonical.Hostname())
    if err != nil || HasDeniedAddress(ips) {
        return nil, ErrAddressDenied
    }

    req, _ := http.NewRequestWithContext(ctx, http.MethodGet, canonical.String(), nil)
    req = PinResolvedDestination(req, ips)
    req.Header.Del("Authorization")
    return client.Do(req)
}

func HasDeniedAddress(ips []net.IPAddr) bool {
    for _, ip := range ips {
        if IsLoopbackPrivateLinkLocalMulticastOrUniqueLocal(ip.IP) ||
           IsIPv4MappedDeniedRange(ip.IP) ||
           IsCloudMetadataEndpoint(ip.IP) {
            return true
        }
    }
    return false
}
```

## Evidence Matrix

| Evidence ID | Location | URL Source | Parser Consistency | Redirect Revalidation | DNS / Final IP Evidence | Metadata Deny | Alternate Encoding Handling | Scheme Control | Confidence |
|-------------|----------|------------|--------------------|-----------------------|-------------------------|---------------|-----------------------------|----------------|------------|
| SCR-SSRF-01 | `safe_fetch.go:7-14` | import preview URL | Pass: `ParseCanonicalHTTPSURL` feeds validation and request construction | Pass | Pass | Pass | Pass through canonical parser | HTTPS only | High |
| SCR-SSRF-02 | `safe_fetch.go:18-31` | redirect targets | Pass | Pass: `CheckRedirect` revalidates each target | Pass: redirect host is resolved and pinned | Pass | Pass | HTTPS and allowlist enforced per hop | High |
| SCR-SSRF-03 | `safe_fetch.go:34-41` | final request | Pass | Pass | Pass: resolver lookup occurs before request and destination is pinned | Pass | Pass | HTTPS only | High |
| SCR-SSRF-04 | `safe_fetch.go:45-55` | denied ranges | Pass | Pass | Pass: loopback/private/link-local/multicast/unique-local and IPv4-mapped denied | Pass | Pass | N/A | High |
| SCR-SSRF-05 | `safe_fetch.go:51` | metadata endpoints | Pass | Pass | Pass | Pass: metadata endpoint helper is explicit | Pass | N/A | High |
| SCR-SSRF-06 | `safe_fetch.go:20-23` | redirects | Pass | Pass | Pass | Pass | Pass | Pass: scheme downgrade blocked | High |
| SCR-SSRF-07 | `safe_fetch.go:16,39-40` | outbound request | Pass | Pass | Pass | Pass | Pass | Pass: timeout set and credentials removed | High |
| SCR-SSRF-08 | reviewer conclusion | full path | High confidence | High confidence | High confidence | High confidence | High confidence | High confidence | High |

## Expected Review Behavior

- Do not report SSRF only because the code fetches a user-provided URL.
- Record the fetch path as high-confidence mitigated when the implementation can be verified.
- If `ParseCanonicalHTTPSURL`, `PinResolvedDestination`, or deny-range helpers are not in review scope, mark those subchecks Not Evaluable rather than Pass.

## Acceptable Finding Shape

```text
SSRF URL Fetch Review: mitigated
Evidence ID(s): SCR-SSRF-01 through SCR-SSRF-08
Parser Consistency: Pass
Redirect Revalidation: Pass
DNS / Final IP Evidence: Pass
Metadata Deny: Pass
Alternate Encoding Handling: Pass
Scheme Control: Pass
Confidence: High
```
