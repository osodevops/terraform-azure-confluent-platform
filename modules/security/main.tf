data "azurerm_client_config" "current" {}

# -----------------------------------------------------------------------------
# Confluent Platform namespace
# -----------------------------------------------------------------------------
resource "kubernetes_namespace" "confluent" {
  metadata {
    name = var.confluent_namespace

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/part-of"    = "confluent-platform"
    }
  }
}

# -----------------------------------------------------------------------------
# Azure Key Vault
# -----------------------------------------------------------------------------
resource "azurerm_key_vault" "main" {
  name                       = substr("${replace(var.name_prefix, "-", "")}kv", 0, 24)
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  tags = var.tags
}

# Grant the kubelet identity read access to Key Vault secrets.
resource "azurerm_role_assignment" "kubelet_kv_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.kubelet_identity_object_id
}
