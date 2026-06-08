# Benign Fixture: Strict Mesh With Default Deny and Bounded Exceptions

## Scenario

The `payments` namespace uses service mesh policy and CNI NetworkPolicy together. Mesh enrollment is mandatory, host-network paths are disallowed, and the only debug exception is temporary and destination-bounded.

## Evidence

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: payments
  labels:
    istio-injection: enabled
    policy.corp.example/sidecar-required: "true"
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: payments
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-payment-api-to-db
  namespace: payments
spec:
  podSelector:
    matchLabels:
      app: payment-db
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: payment-api
      ports:
        - protocol: TCP
          port: 5432
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
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-api
  namespace: payments
spec:
  template:
    metadata:
      labels:
        app: payment-api
    spec:
      hostNetwork: false
      containers:
        - name: api
          image: example.local/payment-api@sha256:1111
```

Policy inventory confirms:

- Cilium policy enforcement is `always`.
- Admission policy rejects `hostNetwork: true`, `hostPort`, and `sidecar.istio.io/inject: "false"` in `payments`.
- The only break-glass debug role is approved by `payments-sre`, expires on `2026-06-15`, and is allowed to reach only `payment-api:8443` from a labeled debug pod that still receives a sidecar.
- Flow logs show denied attempts from non-mesh namespaces to `payment-db`.

## Expected Assessment

- Do not flag flat east-west connectivity solely because the namespace uses a service mesh.
- Mark service mesh bypass controls as **Verified**.
- Mark `hostNetwork` / `hostPort` exceptions as **None** or **Approved** based on the exception inventory.
- Mark default-deny and CNI enforcement as **Verified**.
