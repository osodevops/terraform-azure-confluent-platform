mock_provider "azurerm" {}
mock_provider "helm" {}
mock_provider "kubernetes" {}
mock_provider "kubectl" {}

# Test: module plans successfully with minimal inputs
run "minimal_inputs_plan" {
  command = plan

  variables {
    name        = "test-confluent"
    environment = "test"
    location    = "uksouth"
  }
}

# Test: optional components can be disabled
run "all_optional_components_disabled" {
  command = plan

  variables {
    name        = "test-confluent"
    environment = "test"
    location    = "uksouth"

    schema_registry    = { enabled = false }
    connect            = { enabled = false }
    ksqldb             = { enabled = false }
    control_center     = { enabled = false }
    kafka_rest_proxy   = { enabled = false }
    monitoring_enabled = false
  }
}

# Test: all components enabled
run "all_components_enabled" {
  command = plan

  variables {
    name        = "test-confluent"
    environment = "test"
    location    = "uksouth"

    schema_registry    = { enabled = true, replicas = 2 }
    connect            = { enabled = true, replicas = 2 }
    ksqldb             = { enabled = true, replicas = 2 }
    control_center     = { enabled = true }
    kafka_rest_proxy   = { enabled = true, replicas = 2 }
    monitoring_enabled = true
  }
}
