# -----------------------------------------------------------------------------
# Managed identity for cert-manager (DNS-01 challenge solving, etc.)
# -----------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "cert_manager" {
  name                = "${var.name_prefix}-cert-manager"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Federate the identity to the cert-manager Kubernetes service account via OIDC.
resource "azurerm_federated_identity_credential" "cert_manager" {
  name                = "${var.name_prefix}-cert-manager"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.cert_manager.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_oidc_issuer_url
  subject             = "system:serviceaccount:cert-manager:cert-manager"
}
