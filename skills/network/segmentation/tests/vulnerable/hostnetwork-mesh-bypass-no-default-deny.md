# Vulnerable Fixture: hostNetwork Mesh Bypass Without Default Deny

## Scenario

A production `payments` namespace uses Istio AuthorizationPolicy for mesh-enrolled services, but one node-level diagnostic DaemonSet bypasses the proxy path and can reach the protected database network.

## Evidence

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: payments
  labels:
    istio-injection: enabled
---
apiVersion: security.istio.io/v1
kind: PeerAuthentication
metadata:
  name: payments-mtls
  namespace: payments
spec:
  mtls:
    mode: STRICT
---
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: allow-api-to-db
  namespace: payments
spec:
  selector:
    matchLabels:
      app: payment-db
  rules:
    - from:
        - source:
            principals:
              - cluster.local/ns/payments/sa/payment-api
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-debug-shell
  namespace: payments
  annotations:
    exception.owner: ""
    exception.expires: "2026-04-30"
spec:
  selector:
    matchLabels:
      app: node-debug-shell
  template:
    metadata:
      labels:
        app: node-debug-shell
      annotations:
        sidecar.istio.io/inject: "false"
    spec:
      hostNetwork: true
      serviceAccountName: node-debug
      containers:
        - name: shell
          image: example.local/debug-shell:latest
          ports:
            - containerPort: 5432
              hostPort: 5432
          env:
            - name: TEST_TARGET
              value: payment-db.payments.svc.cluster.local:5432
```

No `NetworkPolicy` or CNI default-deny policy exists in the namespace. The cluster policy inventory shows CNI policy enforcement as `unknown`. Flow logs show `node-debug-shell` connecting to `payment-db.payments.svc.cluster.local:5432` by node source IP.

## Expected Assessment

- Flag a **High** finding for service mesh bypass through `hostNetwork` and `hostPort`.
- Note that Istio policy and strict mTLS for mesh workloads do not cover the debug DaemonSet because sidecar injection is disabled.
- Require default-deny NetworkPolicy or CNI enforcement, removal of `hostNetwork` / `hostPort`, and a bounded exception record with owner, expiry, and allowed destinations.
- Do not classify the namespace as fully micro-segmented until non-mesh paths are denied.
