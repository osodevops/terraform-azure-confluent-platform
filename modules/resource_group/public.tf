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

resource "azurerm_network_security_rule" "control-centre-rest-proxy" {
  name                       = "control-centre"
  priority                   = 200
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_ranges     = ["9021", "8082"]
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name        = azurerm_resource_group.confluent.name
  network_security_group_name = azurerm_network_security_group.public.name
}

# Associate network security group with public subnet.
resource "azurerm_subnet_network_security_group_association" "public_subnet_assoc" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.public.id
}