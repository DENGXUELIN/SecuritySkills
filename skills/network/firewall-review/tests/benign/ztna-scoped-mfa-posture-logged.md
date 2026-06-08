---
case: ztna-scoped-mfa-posture-logged
expected: pass
skill: firewall-review
---

# Benign Case: Scoped ZTNA Access With MFA, Posture, DNS, and Logging Evidence

## Remote Access Facts

- ZTNA policy: `prod-support-web-admin`.
- Group scope: named `Prod-Web-Support-L3`; owner is the platform operations manager; access reviewed on 2026-05-31.
- MFA enforcement: phishing-resistant MFA required; break-glass users are separate and alert-only.
- Client posture: managed device, EDR healthy, disk encrypted, device certificate present, and critical patches current.
- Route scope: per-app access to `admin.prod-web.example.internal:443`; no network-level route to database, backup, hypervisor, or firewall management subnets.
- Split tunnel: internet traffic exits locally, but ZTNA application traffic and internal DNS use the managed tunnel.
- DNS policy: clients use the assigned internal resolver and DoH/DoT to external resolvers is blocked while connected.
- Management-plane access: firewall UI, cloud console, IdP admin, PAM, and backup console are denied by this policy.
- Session logging: login, logout, source IP, device ID, posture result, assigned app, policy decision, bytes, and session recording link are retained in SIEM for 180 days.

## Expected Skill Behavior

The remote-access evidence decision may be `Pass`.

The report should preserve:

- MFA and posture evidence;
- named group owner and review date;
- exact ZTNA app scope;
- sensitive network denial evidence;
- DNS policy and leak controls;
- session logging fields and retention destination.
