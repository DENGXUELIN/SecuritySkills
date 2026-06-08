# Vulnerable Fixture: User-Controlled Template Source and Raw Email HTML

## Scenario

A code review accepts a Flask rendering flow because the output is "sanitized"
in a general XSS checklist. The same change also compiles a user-controlled
template string, exposes application configuration to that template, disables
autoescape, and marks customer-supplied email HTML safe before rendering.

## Code Snapshot

```python
from flask import current_app, request, render_template
from jinja2 import Environment, FileSystemLoader
from markupsafe import Markup

env = Environment(
    loader=FileSystemLoader("templates"),
    autoescape=False,
)

@app.post("/preview")
def preview():
    template = env.from_string(request.json["template"])
    return template.render(user=current_user, config=current_app.config)

@app.post("/campaign")
def campaign_email():
    cta = Markup(request.form["cta_html"])
    return render_template("email/campaign.html", cta=cta)
```

## Evidence Snapshot

| Field | Value |
|---|---|
| Template engine and source control | Jinja; preview endpoint compiles `request.json["template"]` |
| Sandbox and loader posture | Default unrestricted `Environment`; filesystem loader available |
| Exposed globals and helpers | `current_user` and app `config` are passed into user-controlled templates |
| Autoescape and output contexts | `autoescape=False`; campaign CTA renders in HTML email body |
| Raw/safe override status | `Markup(request.form["cta_html"])` marks untrusted HTML safe |
| Sanitizer policy | None documented for template source or CTA HTML |
| Regression coverage | No SSTI or email HTML XSS tests |
| Template review confidence | Low |

## Problem Indicators

- `SCR-TPL-01`: User input is compiled as template source.
- `SCR-TPL-02`: Untrusted templates run in an unrestricted engine.
- `SCR-TPL-03`: App configuration is exposed to user-controlled template code.
- `SCR-TPL-04`: Autoescape is disabled for rendered HTML.
- `SCR-TPL-05`: HTML email context is not reviewed separately from text preview.
- `SCR-TPL-06`: User-controlled CTA HTML is marked safe before validation.
- `SCR-TPL-07`: No sanitizer allowlist or protocol policy is documented.
- `SCR-TPL-08`: No known-bad SSTI or sink-specific XSS regression exists.

## Expected Finding

Classify as **High** because the preview path enables server-side template
injection and the email path can render attacker-controlled HTML in a high-trust
customer communication channel.

## Required Remediation

Use fixed or allowlisted template names, move tenant-editable templates to a
sandboxed environment with restricted loaders and helpers, remove dangerous
globals, enable autoescape for HTML templates and email HTML, sanitize rich text
with an explicit allowlist before any raw/safe override, and add regression tests
for SSTI payloads, HTML body escaping, URL attributes, and benign allowed markup.
