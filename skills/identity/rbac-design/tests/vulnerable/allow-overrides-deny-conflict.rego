package rbac.precedence.vulnerable

import rego.v1

default allow := false

allow if {
  input.subject.roles[_] == "finance-reader"
  input.action == "read"
}

allow if {
  input.subject.roles[_] == "tenant-admin"
}

deny if {
  input.subject.status == "suspended"
}

deny if {
  input.subject.tenant != input.resource.tenant
}

deny if {
  input.resource.sensitivity == "restricted"
  not input.environment.device_compliant
}

test_suspended_user_is_incorrectly_allowed if {
  allow with input as {
    "subject": {
      "roles": ["finance-reader"],
      "tenant": "tenant-a",
      "status": "suspended"
    },
    "resource": {
      "type": "finance-report",
      "tenant": "tenant-a",
      "sensitivity": "standard"
    },
    "action": "read",
    "environment": {
      "device_compliant": true
    }
  }
}

test_cross_tenant_admin_is_incorrectly_allowed if {
  allow with input as {
    "subject": {
      "roles": ["tenant-admin"],
      "tenant": "tenant-a",
      "status": "active"
    },
    "resource": {
      "type": "finance-report",
      "tenant": "tenant-b",
      "sensitivity": "standard"
    },
    "action": "read",
    "environment": {
      "device_compliant": true
    }
  }
}

test_missing_device_posture_is_incorrectly_allowed if {
  allow with input as {
    "subject": {
      "roles": ["finance-reader"],
      "tenant": "tenant-a",
      "status": "active"
    },
    "resource": {
      "type": "finance-report",
      "tenant": "tenant-a",
      "sensitivity": "restricted"
    },
    "action": "read",
    "environment": {}
  }
}
