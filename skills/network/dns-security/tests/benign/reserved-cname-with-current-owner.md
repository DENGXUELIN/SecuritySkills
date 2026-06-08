---
name: benign-reserved-cname-with-current-owner
expected: pass
---

# Benign DNS takeover fixture

## DNS record

```
docs.example.com. 300 IN CNAME vendor.example-host.com.
```

## Evidence

| Field | Value |
|-------|-------|
| Provider | Vendor Docs Hosting |
| Owner | Documentation platform team |
| Reservation status | Active custom domain attached to production tenant |
| Claimability evidence | Vendor API shows `docs.example.com` is reserved by tenant `docs-prod-123`; unrelated tenant add attempt is rejected |
| Last verification date | 2026-06-08 |
| Decision | Keep and reverify quarterly |

## Expected review result

Pass the takeover check. The record looks third-party-hosted, but owner, reservation, and negative claimability evidence are current.
