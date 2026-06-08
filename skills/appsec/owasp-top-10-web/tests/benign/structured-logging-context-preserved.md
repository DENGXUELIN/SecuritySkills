# Benign Fixture: Structured Logging With Reserved Fields Protected

## Scenario

A login failure path uses fixed top-level event fields, encodes user-controlled text, stores user input under a nested metadata object, and includes the audit context needed for investigation.

## Evidence Presented

```javascript
const sanitizeForLog = (value) =>
  String(value).replace(/[\r\n\t\u001b]/g, (char) => JSON.stringify(char).slice(1, -1));

app.post("/login", async (req, res) => {
  const user = await users.findByEmail(req.body.email);
  const requestId = req.headers["x-request-id"] || crypto.randomUUID();

  if (!user || !(await verifyPassword(req.body.password, user.passwordHash))) {
    audit.warn({
      event: "login_failed",
      level: "warn",
      outcome: "denied",
      actor: user ? user.id : "unknown",
      action: "login",
      resource: "session",
      source_ip: req.ip,
      request_id: requestId,
      timestamp: new Date().toISOString(),
      metadata: {
        email_hint: sanitizeForLog(req.body.email),
        user_agent: sanitizeForLog(req.get("user-agent") || "unknown")
      }
    });

    return res.status(401).json({ error: "invalid credentials" });
  }

  res.json({ ok: true });
});
```

## Expected Finding

Do not report log forging for this path. It satisfies `LOG-FORGE-01` through `LOG-FORGE-05`: attacker-controlled data is nested and neutralized, top-level audit fields are trusted constants or server-derived values, required actor/action/resource/outcome/source/timestamp/request ID context is present, and sensitive data such as the password is not logged. If downstream SIEM behavior is unknown, route only `LOG-FORGE-07` as a validation note rather than a confirmed vulnerability.
