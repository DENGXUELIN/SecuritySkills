# Vulnerable Fixture: Refresh Token in LocalStorage With Query Fallback

## Scenario

A single-page application stores a long-lived refresh token in `localStorage` and also accepts a `token` query parameter during OAuth callback handling. The session cookie exists, but it is not the only authentication material.

## Evidence

```javascript
// src/auth/session.js
export function persistAuth(authResponse) {
  localStorage.setItem("access_token", authResponse.accessToken);
  localStorage.setItem("refresh_token", authResponse.refreshToken);
  localStorage.setItem("expires_at", String(Date.now() + 30 * 24 * 60 * 60 * 1000));
}

export function readTokenFromCallback(req) {
  const token = req.query.token || req.body.token;
  if (token) {
    console.info("oauth callback token", req.originalUrl);
    return token;
  }
  return null;
}
```

```http
Set-Cookie: sid=abc123; Path=/; SameSite=Lax
```

## Expected Result

The skill should classify this as High. Bearer and refresh tokens are browser-readable, long-lived, and accepted from query strings that can leak through logs, browser history, and Referer headers. The presence of a session cookie without `HttpOnly` and without server-side rotation evidence does not suppress the finding.
