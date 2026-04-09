variable "existing_vnet_id" {
  description = "ID of the existing VNet."
  type        = string
}

variable "existing_aks_subnet_id" {
  description = "ID of the existing AKS subnet."
  type        = string
}

module "confluent_platform" {
  source = "../../"

  name        = "confluent"
  environment = "production"
  location    = "uksouth"

  existing_vnet_id       = var.existing_vnet_id
  existing_aks_subnet_id = var.existing_aks_subnet_id

  kafka = {
    replicas     = 3
    storage_size = "500Gi"
  }

  schema_registry = { enabled = true }
  control_center  = { enabled = true }
}
