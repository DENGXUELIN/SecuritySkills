# Benign: Constrained Egress Boundary

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
          target: firewall-egress-eni
      security_group_egress:
        - protocol: tcp
          port: 443
          destination: sg-egress-proxy
        - protocol: udp
          port: 53
          destination: resolver-endpoint-prod
      enforcement_points:
        web: egress-proxy-prod
        dns: dns-firewall-prod
        dlp: dlp-policy-prod-app
        firewall: network-firewall-prod
      approved_destinations:
        - type: fqdn
          value: api.partner.example.test
          owner: payments-platform
          ticket: NET-4312
        - type: private_endpoint
          value: vpce-0abc123partner
          owner: payments-platform
          ticket: NET-4313
      denied_destinations:
        - paste.example.test
        - public-dns-resolvers
        - unknown-saas-category
      dns_resolvers:
        allowed:
          - resolver-endpoint-prod
        blocked:
          - 8.8.8.8
          - 1.1.1.1
      logging:
        flow_logs: siem:index=vpc-flow-prod
        proxy_logs: siem:index=egress-proxy-prod
        dns_logs: siem:index=dns-firewall-prod
        firewall_denies: siem:index=network-firewall-prod
        dlp_events: siem:index=dlp-prod
      exceptions:
        - id: NET-4420
          destination: vendor-maintenance.example.test
          owner: platform-network
          approved_by: security-architecture
          expires: 2026-06-30
          compensating_control: mTLS + DLP monitor + vendor IP pinning
          last_reviewed: 2026-06-01

observed_tests:
  generic_https:
    source: production-app
    destination: https://paste.example.test
    result: blocked
    evidence: proxy_deny_event_9001
  public_dns:
    source: production-app
    destination: 8.8.8.8:53
    result: blocked
    evidence: dns_firewall_deny_314
  approved_partner:
    source: production-app
    destination: https://api.partner.example.test
    result: allowed
    evidence: proxy_allow_event_7821
  alternate_nat_route:
    source: production-app
    destination: internet
    result: no_route_without_firewall

claimed_result: segmented_with_constrained_egress
```

## Expected Review Result

| Gate | Status | Evidence |
|------|--------|----------|
| Approved destinations | Pass | Partner FQDN and private endpoint are inventoried with owners and tickets. |
| Enforcement point | Pass | Web, DNS, DLP, and firewall controls are identified for the source zone. |
| Bypass review | Pass | Internet route sends traffic to firewall egress ENI and alternate NAT path is absent. |
| DNS path | Pass | Public resolvers are blocked and internal resolver logs are retained. |
| Port 443 constraints | Pass | Security group permits `tcp/443` only to the egress proxy, not to any destination. |
| Logging | Pass | Flow, proxy, DNS, firewall deny, and DLP log indexes are listed. |
| Exception lifecycle | Pass | Temporary exception has owner, approver, expiry, compensating control, and review date. |

## Reviewer Notes

This evidence supports treating the production app zone as segmented with controlled egress. Continue testing denied destinations during segmentation validation and ensure exceptions expire or are reapproved before their review date.
