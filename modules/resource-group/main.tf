resource "azurerm_resource_group" "confluent" {
  name     = "${local.uid}-resources"
  location = var.location
}

#TODO: Template out these CIDR ranges
resource "azurerm_virtual_network" "confluent" {
  name                = "${local.uid}-network"
  resource_group_name = azurerm_resource_group.confluent.name
  location            = azurerm_resource_group.confluent.location
  address_space       = ["10.0.0.0/16"]
}

#TODO: Template out these CIDR ranges
resource "azurerm_subnet" "confluent" {
  name                 = var.internal_subnet_name
  virtual_network_name = azurerm_virtual_network.confluent.name
  resource_group_name  = azurerm_resource_group.confluent.name
  address_prefixes     = ["10.0.1.0/24"]
}



