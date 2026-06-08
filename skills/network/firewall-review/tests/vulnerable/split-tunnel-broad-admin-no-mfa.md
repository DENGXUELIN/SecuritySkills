---
case: split-tunnel-broad-admin-no-mfa
expected: fail
skill: firewall-review
---

# Vulnerable Case: Split-Tunnel VPN With Broad Admin Reachability

## Remote Access Facts

- VPN profile: `contractor-split-tunnel`.
- Group scope: nested `All-Contractors` IdP group; no named owner or recertification date.
- MFA enforcement: password-only exception for the contractor profile.
- Client posture: no managed-device, EDR, disk-encryption, certificate, or patch-compliance requirement.
- Split-tunnel routes: `10.0.0.0/8` internal routes included; internet traffic exits locally.
- Sensitive networks reachable: database subnet `10.42.0.0/16`, production admin jump hosts, firewall management UI, and backup console.
- DNS policy: clients can use local resolvers; no internal DNS leak test or DoH/DoT control.
- Session logging: login and logout only; no assigned IP, device ID, posture result, route access, or bytes transferred.

## Expected Skill Behavior

The remote-access evidence decision should be `Fail`, with High findings for:

- broad internal and management-plane access over split tunnel;
- missing MFA for users with sensitive internal reachability;
- unmanaged nested group scope;
- missing client posture checks;
- DNS leakage risk;
- insufficient session logging for route-level accountability.

The firewall review should not mark default-deny or east-west policy as effective until this remote-access bypass path is remediated or explicitly isolated.
