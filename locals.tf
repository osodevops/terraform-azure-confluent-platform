locals {
  name_prefix = "${var.name}-${var.environment}"

  common_tags = merge(var.tags, {
    ManagedBy   = "terraform"
    Module      = "osodevops/confluent-platform/azure"
    Environment = var.environment
  })

  create_networking = var.existing_vnet_id == null
  aks_subnet_id     = local.create_networking ? module.networking[0].aks_subnet_id : var.existing_aks_subnet_id

  component_flags = {
    schema_registry  = var.schema_registry.enabled
    connect          = var.connect.enabled
    ksqldb           = var.ksqldb.enabled
    control_center   = var.control_center.enabled
    kafka_rest_proxy = var.kafka_rest_proxy.enabled
  }
}
