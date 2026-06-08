# Vulnerable Fixture: Log Forging Through CRLF and Reserved Field Overwrite

## Scenario

A Node.js login endpoint writes failed-login events to a line-oriented audit log and also spreads request JSON into a structured event. The username and request body are attacker controlled.

## Evidence Presented

```javascript
app.post("/login", async (req, res) => {
  const user = await users.findByEmail(req.body.email);

  if (!user || !(await verifyPassword(req.body.password, user.passwordHash))) {
    logger.warn("login_failed user=" + req.body.email + " ip=" + req.ip);

    audit.info({
      event: "login_failed",
      level: "warn",
      outcome: "denied",
      user_id: user ? user.id : "unknown",
      source_ip: req.ip,
      ...req.body
    });

    return res.status(401).json({ error: "invalid credentials" });
  }

  res.json({ ok: true });
});
```

Example payload:

```json
{
  "email": "alice@example.test\n2026-06-09T04:00:00Z INFO event=password_reset outcome=success user_id=admin",
  "password": "wrong",
  "event": "payment_approved",
  "outcome": "success",
  "level": "info",
  "user_id": "admin",
  "trace_id": "forged-trace"
}
```

## Expected Finding

Report this as an A09 / CWE-117 and structured-log forging finding. It fails `LOG-FORGE-01`, `LOG-FORGE-02`, `LOG-FORGE-03`, and `LOG-FORGE-07`: attacker-controlled values reach log sinks, CR/LF can create a forged line-oriented event, untrusted request fields overwrite reserved structured fields, and there is no evidence that the downstream SIEM preserves the original event boundary or field ownership.
