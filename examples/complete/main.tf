module "confluent_platform" {
  source = "../../"

  name        = "confluent"
  environment = "production"
  location    = "uksouth"

  kubernetes_version = "1.30"
  aks_sku_tier       = "Standard"

  confluent_node_pool = {
    vm_size   = "Standard_D16s_v5"
    min_count = 3
    max_count = 12
  }

  confluent_platform_version = "7.7.1"

  kraft_controller = {
    replicas     = 3
    storage_size = "50Gi"
  }

  kafka = {
    replicas     = 3
    storage_size = "500Gi"
  }

  schema_registry = {
    enabled  = true
    replicas = 2
  }

  connect = {
    enabled  = true
    replicas = 2
  }

  ksqldb = {
    enabled      = true
    replicas     = 2
    storage_size = "100Gi"
  }

  control_center = {
    enabled  = true
    replicas = 1
  }

  kafka_rest_proxy = {
    enabled  = true
    replicas = 2
  }

  tls_auto_generated = true
  rbac_enabled       = true
  monitoring_enabled = true

  tags = {
    Project = "confluent-platform"
    Team    = "platform-engineering"
  }
}
