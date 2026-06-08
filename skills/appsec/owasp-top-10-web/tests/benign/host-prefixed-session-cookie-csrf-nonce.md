# Benign Fixture: Host-Prefixed Session Cookie With CSRF Nonce

## Scenario

A web application uses a framework-managed server-side session. The authentication token is only in an `HttpOnly` `__Host-` cookie, while `sessionStorage` holds a short-lived CSRF nonce that is independently validated server-side and rotated per form.

## Evidence

```http
Set-Cookie: __Host-session=opaque-id; Path=/; Secure; HttpOnly; SameSite=Lax; Max-Age=1800
```

```javascript
// src/csrf.js
export function storeCsrfNonce(nonce) {
  sessionStorage.setItem("csrf_nonce", nonce);
}

export function buildFormHeaders() {
  return {
    "X-CSRF-Nonce": sessionStorage.getItem("csrf_nonce")
  };
}
```

```yaml
session_config:
  server_side_store: redis
  rotate_on_login: true
  rotate_on_mfa: true
  rotate_on_privilege_change: true
  idle_timeout_minutes: 30
  absolute_timeout_hours: 8
  cookie:
    prefix: "__Host-"
    secure: true
    http_only: true
    same_site: Lax
    path: /
    domain: null
csrf:
  nonce_lifetime_minutes: 10
  nonce_reuse_allowed: false
```

## Expected Result

The skill should not report browser-token storage for the CSRF nonce alone. The authentication session is server-side, protected by `Secure` and `HttpOnly`, not exposed through URLs, rotates on important state changes, and has finite idle and absolute expiry.
