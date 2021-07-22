# Create public subnet for hosting control-centre/kafka-rest VMs.
resource "azurerm_subnet" "public_subnet" {
  name                      = var.public_subnet_name
  resource_group_name       = azurerm_resource_group.confluent.name
  virtual_network_name      = azurerm_virtual_network.confluent.name
  address_prefixes          = ["10.0.3.0/24"]
}

# Create network security group and SSH rule for public subnet.
resource "azurerm_network_security_group" "public" {
  name                = "confluent-public"
  location            = var.location
  resource_group_name = azurerm_resource_group.confluent.name
}