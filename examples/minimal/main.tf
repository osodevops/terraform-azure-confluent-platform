module "confluent_platform" {
  source = "../../"

  name        = "confluent-dev"
  environment = "dev"
  location    = "uksouth"

  aks_sku_tier = "Free"

  confluent_node_pool = {
    vm_size   = "Standard_D8s_v5"
    min_count = 3
    max_count = 6
  }

  kafka = {
    replicas     = 3
    storage_size = "100Gi"
  }

  schema_registry = {
    enabled  = true
    replicas = 1
  }

  connect          = { enabled = false }
  ksqldb           = { enabled = false }
  control_center   = { enabled = false }
  kafka_rest_proxy = { enabled = false }

  rbac_enabled       = false
  monitoring_enabled = false
}
