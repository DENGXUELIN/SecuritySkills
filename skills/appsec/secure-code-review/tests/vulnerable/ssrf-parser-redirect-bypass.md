---
name: ssrf-parser-redirect-bypass
expected: vulnerable
skill: secure-code-review
---

# Secure Code Review Fixture: SSRF Parser and Redirect Bypass

Use this fixture to verify that `secure-code-review` does not accept a shallow host allowlist as complete SSRF protection.

## Review Scope

File under review: `services/preview/fetch.go`

```go
func preview(w http.ResponseWriter, r *http.Request) {
    raw := r.URL.Query().Get("url")

    parsed, _ := url.Parse(raw)
    if parsed.Scheme != "https" {
        http.Error(w, "https only", 400)
        return
    }
    if !strings.HasSuffix(parsed.Host, ".example-cdn.test") {
        http.Error(w, "blocked", 400)
        return
    }

    client := &http.Client{} // follows redirects automatically
    resp, _ := client.Get(raw)
    io.Copy(w, resp.Body)
}
```

## Evidence Matrix

| Evidence ID | Location | URL Source | Parser Consistency | Redirect Revalidation | DNS / Final IP Evidence | Metadata Deny | Alternate Encoding Handling | Scheme Control | Confidence |
|-------------|----------|------------|--------------------|-----------------------|-------------------------|---------------|-----------------------------|----------------|------------|
| SCR-SSRF-01 | `fetch.go:4-13` | `url` query param | Fail: validation parses `parsed.Host`, fetch uses original raw string | Not checked | Not checked | Not checked | Not checked | Partially checks initial scheme only | High |
| SCR-SSRF-02 | `fetch.go:15` | HTTP client redirect handling | Unknown | Fail: default client follows redirects automatically | Not checked after redirect | Metadata redirect can be followed | Not checked | Redirect can change scheme/host | High |
| SCR-SSRF-03 | `fetch.go:8-15` | Host allowlist | Hostname only | Not checked | Fail: no resolver pinning or final IP range checks | Not checked | Not checked | Not checked | High |
| SCR-SSRF-04 | `fetch.go:8` | `parsed.Host` suffix | Fail: suffix check can miss parser edge cases | Not checked | No private/link-local/IPv6 checks | No explicit `169.254.169.254` deny | Decimal/octal/hex IP forms not normalized | Not checked | Medium |
| SCR-SSRF-05 | `fetch.go:15` | outbound request | Not checked | Not checked | Not checked | Fail: metadata endpoints not denied | Not checked | Not checked | High |
| SCR-SSRF-06 | `fetch.go:7` | scheme check | Initial `https` only | Redirect not checked | Not checked | Not checked | Not checked | Fail: redirect downgrade/protocol switch not controlled | Medium |
| SCR-SSRF-07 | `fetch.go:15-16` | response copy | Not checked | Not checked | Not checked | Not checked | Not checked | No timeout or size cap | Medium |
| SCR-SSRF-08 | reviewer conclusion | full path | Evidence sufficient for finding | Evidence sufficient for finding | Evidence sufficient for finding | Evidence sufficient for finding | Evidence missing but relevant | Evidence sufficient for finding | High |

## Expected Finding

- Report `CWE-918` with High severity.
- Cite `SCR-SSRF-01`, `SCR-SSRF-02`, `SCR-SSRF-03`, `SCR-SSRF-05`, and `SCR-SSRF-06`.
- Explain that the code validates only the initial parsed host and scheme, then lets the default client follow redirect targets without per-hop validation.
- Require a single canonical parse path, per-hop redirect checks, final IP pinning/range denial, metadata endpoint denial, alternate address normalization, and timeout/size limits.

## Anti-Pattern Under Test

The review fails this fixture if it says:

```text
Status: Pass
Evidence: URL scheme is https and host must end with .example-cdn.test.
SSRF risk: mitigated
```

That conclusion ignores parser consistency, redirect revalidation, DNS rebinding, final IP checks, metadata endpoints, alternate IP encodings, and response limits.
