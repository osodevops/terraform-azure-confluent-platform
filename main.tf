# ---------------------------------------------------------------------------------------------------------------------
# NETWORKING
# ---------------------------------------------------------------------------------------------------------------------

module "networking" {
  count  = local.create_networking ? 1 : 0
  source = "./modules/networking"

  name_prefix                  = local.name_prefix
  location                     = var.location
  tags                         = local.common_tags
  vnet_address_space           = var.vnet_address_space
  aks_subnet_cidr              = var.aks_subnet_cidr
  internal_lb_subnet_cidr      = var.internal_lb_subnet_cidr
  private_endpoint_subnet_cidr = var.private_endpoint_subnet_cidr
}

# ---------------------------------------------------------------------------------------------------------------------
# AKS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

module "aks" {
  source = "./modules/aks"

  name_prefix          = local.name_prefix
  location             = var.location
  tags                 = local.common_tags
  resource_group_name  = local.create_networking ? module.networking[0].resource_group_name : data.azurerm_subnet.existing[0].resource_group_name
  aks_subnet_id        = local.aks_subnet_id
  private_dns_zone_id  = local.create_networking ? module.networking[0].private_dns_zone_id : "System"
  kubernetes_version   = var.kubernetes_version
  sku_tier             = var.aks_sku_tier
  system_node_pool     = var.system_node_pool
  confluent_node_pool  = var.confluent_node_pool
  authorized_ip_ranges = var.aks_authorized_ip_ranges
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY (Key Vault, cert-manager, TLS, RBAC, Network Policies)
# ---------------------------------------------------------------------------------------------------------------------

module "security" {
  source = "./modules/security"

  name_prefix                = local.name_prefix
  location                   = var.location
  tags                       = local.common_tags
  resource_group_name        = local.create_networking ? module.networking[0].resource_group_name : data.azurerm_subnet.existing[0].resource_group_name
  resource_group_id          = local.create_networking ? module.networking[0].resource_group_id : data.azurerm_subnet.existing[0].id
  aks_oidc_issuer_url        = module.aks.oidc_issuer_url
  kubelet_identity_object_id = module.aks.kubelet_identity_object_id
  confluent_namespace        = var.cfk_namespace
  tls_auto_generated         = var.tls_auto_generated
  tls_custom_ca_secret       = var.tls_custom_ca_secret
  rbac_enabled               = var.rbac_enabled
  mds_super_users            = var.mds_super_users
  component_flags            = local.component_flags
}

# ---------------------------------------------------------------------------------------------------------------------
# CFK OPERATOR
# ---------------------------------------------------------------------------------------------------------------------

module "cfk_operator" {
  source = "./modules/cfk_operator"

  operator_version = var.cfk_operator_version
  namespace        = module.security.confluent_namespace
  namespaced       = var.cfk_namespaced
  create_namespace = false

  depends_on = [module.security]
}

# ---------------------------------------------------------------------------------------------------------------------
# CONFLUENT PLATFORM COMPONENTS
# ---------------------------------------------------------------------------------------------------------------------

module "confluent_platform" {
  source = "./modules/confluent_platform"

  namespace                  = module.security.confluent_namespace
  confluent_platform_version = var.confluent_platform_version

  kraft_controller = var.kraft_controller
  kafka            = var.kafka
  schema_registry  = var.schema_registry
  connect          = var.connect
  ksqldb           = var.ksqldb
  control_center   = var.control_center
  kafka_rest_proxy = var.kafka_rest_proxy

  tls_auto_generated   = var.tls_auto_generated
  tls_custom_ca_secret = var.tls_custom_ca_secret
  rbac_enabled         = var.rbac_enabled
  mds_super_users      = var.mds_super_users
  mds_token_secret     = module.security.mds_token_secret_name

  depends_on = [module.cfk_operator]
}

# ---------------------------------------------------------------------------------------------------------------------
# MONITORING
# ---------------------------------------------------------------------------------------------------------------------

module "monitoring" {
  count  = var.monitoring_enabled ? 1 : 0
  source = "./modules/monitoring"

  confluent_namespace  = module.security.confluent_namespace
  prometheus_namespace = var.prometheus_namespace
  component_flags      = local.component_flags
}

# ---------------------------------------------------------------------------------------------------------------------
# DATA SOURCES (for bring-your-own-vnet)
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_subnet" "existing" {
  count = local.create_networking ? 0 : 1

  name                 = split("/", var.existing_aks_subnet_id)[10]
  virtual_network_name = split("/", var.existing_aks_subnet_id)[8]
  resource_group_name  = split("/", var.existing_aks_subnet_id)[4]
}
