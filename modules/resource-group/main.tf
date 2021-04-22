resource "azurerm_resource_group" "confluent" {
  name     = "${local.uid}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "confluent" {
  name                = "${local.uid}-network"
  resource_group_name = azurerm_resource_group.confluent.name
  location            = azurerm_resource_group.confluent.location
  address_space       = ["10.0.0.0/16"]
}
