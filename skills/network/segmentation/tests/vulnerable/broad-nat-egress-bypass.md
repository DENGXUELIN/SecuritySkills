# Vulnerable: Broad NAT Egress Bypass

## Review Target

```yaml
environment: aws-production
zones:
  - name: production-app
    sensitivity: crown_jewel
    subnet: subnet-app-prod-a
    inbound_segmentation:
      user_to_app: via_load_balancer
      app_to_data: restricted_to_tcp_5432
    east_west_controls:
      kubernetes_default_deny: true
      app_to_app: service_mesh_policy
    outbound:
      route_table:
        - destination: 0.0.0.0/0
          target: nat-gateway-prod-a
      security_group_egress:
        - protocol: tcp
          port: 443
          destination: 0.0.0.0/0
        - protocol: udp
          port: 53
          destination: 0.0.0.0/0
      proxy_required: false
      dns_resolvers:
        - 8.8.8.8
        - 1.1.1.1
      approved_destinations:
        - api.partner.example.test
      dlp_or_swg: not_enforced
      logging:
        vpc_flow_logs: enabled
        proxy_logs: missing
        dns_logs: missing
        deny_logs: missing
      exception:
        owner: unknown
        ticket: NET-2211
        created: 2025-01-17
        expires: never
        compensating_control: none

observed_tests:
  generic_https:
    source: production-app
    destination: https://paste.example.test
    result: allowed
  public_dns:
    source: production-app
    destination: 8.8.8.8:53
    result: allowed
  approved_partner:
    source: production-app
    destination: https://api.partner.example.test
    result: allowed

claimed_result: segmented
```

## Expected Findings

| ID | Severity | Evidence |
|----|----------|----------|
| SEG-EGRESS-01 | High | Crown-jewel production app zone has `0.0.0.0/0` outbound route through NAT without destination-aware enforcement. |
| SEG-EGRESS-02 | Medium | Outbound allowlist is only port-based: any destination on `tcp/443` is allowed. |
| SEG-EGRESS-03 | High | Proxy, SWG, DLP, and service mesh egress controls are not required for internet-bound traffic. |
| SEG-EGRESS-04 | High | Direct external DNS to public resolvers is allowed from the sensitive zone. |
| SEG-EGRESS-05 | High | NAT gateway provides an alternate internet exit around the documented approved partner destination. |
| SEG-EGRESS-06 | Medium | Broad egress exception has no owner, expiry, or compensating control evidence. |
| SEG-EGRESS-07 | Medium | There are no proxy, DNS, deny, or DLP logs to prove enforcement or attempted-bypass detection. |

## Reviewer Notes

Do not mark this environment as segmented just because inbound and east-west controls exist. Require destination-aware egress policy, forced approved DNS, proxy or firewall enforcement, denial logging, and expiry-backed exceptions before giving sensitive zones a pass.
