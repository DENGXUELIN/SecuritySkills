# Benign Fixture: Scoped Ephemeral Debug Container With Audit Evidence

## Scenario

An SRE team uses `kubectl debug` for a production pod that runs a distroless image. The debug path is limited to one namespace and target workload, requires a break-glass role, expires after the incident window, and is recorded by Kubernetes audit logs.

## Evidence

```yaml
debug_session:
  target_namespace: payments-prod
  target_workload: deploy/payment-api
  incident_ticket: INC-4421
  expires_at: "2026-06-08T12:30:00Z"
  created_by: sre-oncall@example.com
  type: ephemeralContainers
  container:
    name: debugger-inc-4421
    image: registry.example.com/debug-tools:2026.06
    securityContext:
      runAsNonRoot: true
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop: ["ALL"]
  rbac:
    role: sre-breakglass-debug
    verbs: ["get", "patch"]
    resources: ["pods", "pods/ephemeralcontainers"]
    resourceNames: ["payment-api-7d9f6c8c6b-2r4mk"]
  audit:
    event_id: audit-20260608-4421
    user: sre-oncall@example.com
    verb: patch
    resource: pods/ephemeralcontainers
    namespace: payments-prod
```

## Expected Result

The skill may downgrade this to Medium/Observation or mark it controlled debug evidence. The access is ephemeral, scoped to a named workload, time-bound, audited, and does not grant broad host namespace, hostPath, or privilege escalation access.
