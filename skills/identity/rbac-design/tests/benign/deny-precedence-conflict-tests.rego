package rbac.precedence.benign

import rego.v1

default allow := false

deny if {
  input.subject.status == "suspended"
}

deny if {
  input.subject.tenant != input.resource.tenant
}

deny if {
  input.action == "approve_payment"
  input.subject.roles[_] == "payment-initiator"
  input.subject.roles[_] == "payment-approver"
}

deny if {
  input.resource.sensitivity == "restricted"
  not input.environment.device_compliant
}

permit if {
  input.subject.roles[_] == "finance-reader"
  input.action == "read"
  input.resource.type == "finance-report"
  input.subject.tenant == input.resource.tenant
}

allow if {
  permit
  not deny
}

test_suspended_user_denied_despite_role_permit if {
  not allow with input as {
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

test_cross_tenant_reader_denied if {
  not allow with input as {
    "subject": {
      "roles": ["finance-reader"],
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

test_missing_device_posture_fails_closed_for_restricted_resource if {
  not allow with input as {
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

test_normal_same_tenant_reader_allowed if {
  allow with input as {
    "subject": {
      "roles": ["finance-reader"],
      "tenant": "tenant-a",
      "status": "active"
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
