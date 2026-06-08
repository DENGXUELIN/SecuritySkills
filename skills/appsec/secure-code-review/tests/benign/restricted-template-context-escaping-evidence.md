# Benign Fixture: Restricted Template Rendering with Context Evidence

## Scenario

A profile and campaign-email flow renders user-provided text and limited rich
text without granting template-source control to users. The review collects
template selection, sandbox, autoescape, sanitizer, and regression evidence
before deciding the rendering path is acceptable.

## Code Snapshot

```python
from flask import abort, request, render_template
from jinja2 import select_autoescape
from jinja2.sandbox import SandboxedEnvironment
from markupsafe import Markup
import bleach

ALLOWED_TEMPLATES = {
    "profile": "profile.html",
    "campaign": "email/campaign.html",
}

CTA_TAGS = ["a", "strong"]
CTA_ATTRIBUTES = {"a": ["href", "rel"]}

tenant_env = SandboxedEnvironment(autoescape=select_autoescape(["html", "xml"]))
tenant_env.globals.clear()

def choose_template(template_id):
    template_name = ALLOWED_TEMPLATES.get(template_id)
    if template_name is None:
        abort(400)
    return template_name

@app.post("/profile")
def profile():
    return render_template(
        choose_template(request.form["template_id"]),
        bio=request.form["bio"],
    )

@app.post("/campaign")
def campaign_email():
    cleaned_cta = bleach.clean(
        request.form["cta_html"],
        tags=CTA_TAGS,
        attributes=CTA_ATTRIBUTES,
        protocols=["https"],
        strip=True,
    )
    return render_template("email/campaign.html", cta=Markup(cleaned_cta))
```

## Evidence Snapshot

| Field | Value |
|---|---|
| Template engine and source control | Jinja; only IDs in `ALLOWED_TEMPLATES` select fixed templates |
| Sandbox and loader posture | Tenant-editable rendering uses `SandboxedEnvironment`; globals cleared |
| Exposed globals and helpers | Minimal explicit context: `bio` and sanitized `cta` only |
| Autoescape and output contexts | Autoescape enabled for HTML/XML; profile `bio` renders as HTML body text |
| Raw/safe override status | Only sanitized CTA HTML is wrapped in `Markup` for the email body |
| Sanitizer policy | Bleach allowlist: `a`, `strong`, `href`, `rel`, HTTPS-only links, strip disallowed markup |
| Regression coverage | SSTI literal remains inert; script tags stripped; unsafe URL protocols stripped; allowed link preserved |
| Template review confidence | High |

## Positive Controls

- `SCR-TPL-01`: Users select from fixed allowlisted templates, not raw template source.
- `SCR-TPL-02`: Tenant-editable rendering uses a sandboxed environment.
- `SCR-TPL-03`: Dangerous globals and broad helpers are not exposed.
- `SCR-TPL-04`: Autoescape is enabled for HTML templates.
- `SCR-TPL-05`: Profile text and HTML email CTA contexts are reviewed separately.
- `SCR-TPL-06`: The only raw/safe override occurs after sanitizer allowlist enforcement.
- `SCR-TPL-07`: Sanitizer tags, attributes, protocols, and strip behavior are documented.
- `SCR-TPL-08`: Regression evidence covers SSTI, disallowed XSS, unsafe URLs, and benign allowed markup.

## Expected Result

Do not flag this path as template-source injection or unsafe raw HTML merely
because it uses templates and limited rich text. Any remaining finding should be
based on missing evidence in a specific sink context, not a generic XSS label.
