---
name: vulnerable-dangling-cname-claimable-saas
expected: fail
---

# Vulnerable DNS takeover fixture

## DNS record

```
docs.example.com. 300 IN CNAME old-docs.vendor-pages.example.
```

## Evidence

| Field | Value |
|-------|-------|
| Provider | Vendor Pages |
| Owner | Unknown; former docs migration owner left the team |
| Reservation status | Deleted app, no active custom-domain reservation |
| Claimability evidence | Fresh test account can add `docs.example.com` after DNS validation prompt |
| Last verification date | Unknown |
| Decision | Remove or reclaim before public exposure |

## Expected review result

Fail the review. The record points to a deleted third-party tenant and the hostname is claimable by another account, so this is a public subdomain takeover risk.
