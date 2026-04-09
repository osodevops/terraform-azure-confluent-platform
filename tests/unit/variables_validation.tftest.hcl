mock_provider "azurerm" {}
mock_provider "helm" {}
mock_provider "kubernetes" {}
mock_provider "kubectl" {}

# Test: name must be lowercase alphanumeric with hyphens
run "name_validation_rejects_uppercase" {
  command = plan

  variables {
    name        = "MyCluster"
    environment = "dev"
    location    = "uksouth"
  }

  expect_failures = [var.name]
}

run "name_validation_rejects_too_short" {
  command = plan

  variables {
    name        = "a"
    environment = "dev"
    location    = "uksouth"
  }

  expect_failures = [var.name]
}

run "name_validation_accepts_valid" {
  command = plan

  variables {
    name        = "my-confluent"
    environment = "dev"
    location    = "uksouth"
  }
}

# Test: AKS SKU tier validation
run "aks_sku_rejects_invalid" {
  command = plan

  variables {
    name         = "test-cluster"
    environment  = "dev"
    location     = "uksouth"
    aks_sku_tier = "Enterprise"
  }

  expect_failures = [var.aks_sku_tier]
}

# Test: SASL mechanism validation
run "sasl_rejects_invalid" {
  command = plan

  variables {
    name           = "test-cluster"
    environment    = "dev"
    location       = "uksouth"
    sasl_mechanism = "GSSAPI"
  }

  expect_failures = [var.sasl_mechanism]
}
