resource "azurerm_resource_group" "example" {
  name     = "${local.uid}-resources"
  location = var.location
}

#TODO: Template out these CIDR ranges
resource "azurerm_virtual_network" "example" {
  name                = "${local.uid}-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

#TODO: Template out these CIDR ranges
resource "azurerm_subnet" "example" {
  name                 = var.internal_subnet_name
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
