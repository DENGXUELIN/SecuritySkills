# Benign: Current Sampled PCI Evidence

## Scenario

The assessor reviews evidence for the same merchant after the PCI team provides a complete evidence package.

## Evidence Freshness and Sample Matrix

| Sub-Req | Testing Procedure | Artifact | Owner/Collector | Evidence Date/Period | Sample Scope | CDE Coverage | Frequency Met | Freshness | Result |
|---------|-------------------|----------|-----------------|----------------------|--------------|--------------|---------------|-----------|--------|
| 10.4.1.1 | Examine and test automated log review | SIEM daily review exports LOG-2026-05-01 through LOG-2026-05-31; alert queue samples SECOPS-901 to SECOPS-932 | SecOps Manager / QSA | 2026-05-01 through 2026-05-31 | All CDE firewalls, WAF, IAM, database audit logs, and security-impacting jump hosts | Complete | Yes, daily review evidence covers the month | Current | Pass |
| 8.4.2 | Examine MFA configuration and test user samples | IdP MFA policy export MFA-2026-06-01; sample tests for admins, developers, support, and service-provider users | Identity Lead / QSA | 2026-06-01 | 32 users across all CDE access paths and remote access groups | Complete | N/A | Current | Pass |
| 11.4.5 | Examine segmentation test report and test retest records | Segmentation test report PEN-2026-Q2 plus retest record RT-881 | Network Security Owner / QSA | 2026-04-10 through 2026-04-25 | Primary CDE VLAN, backup CDE VLAN, jump segment, monitoring segment, and connected-to corporate networks | Complete | Yes, annual segmentation test completed after network change CHG-771 | Current | Pass |
| 12.8.5 | Examine TPSP compliance monitoring | TPSP AOC package AOC-2026-05, responsibility matrix RM-2026-05, and annual review ticket VRM-411 | Vendor Risk Manager / ISA | 2026-05-20 | Payment processor, tokenization provider, managed WAF provider, and logging provider | Complete | Yes, annual monitoring completed | Current | Pass |

## Expected Review Result

The skill should allow `Requirement in Place` where the evidence satisfies `PCI-EVID-01` through `PCI-EVID-08`: testing method, artifact, owner/collector, date/period, sample scope, CDE coverage, required cadence, freshness, and result are all documented.
