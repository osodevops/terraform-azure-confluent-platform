resource azurerm_subnet private {
  name                 = var.private_subnet_name
  virtual_network_name = azurerm_virtual_network.confluent.name
  resource_group_name  = azurerm_resource_group.confluent.name
  address_prefixes     = ["10.0.1.0/24"]
}


# Create network security group and SSH rule for public subnet.
resource azurerm_network_security_group private {
  name                = "confluent-private"
  location            = var.location
  resource_group_name = azurerm_resource_group.confluent.name
  security_rule = [
    {
      access                                     = "Allow"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "*"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "ansible-provision"
      priority                                   = 101
      protocol                                   = "Tcp"
      source_address_prefix                      = "10.0.5.0/24"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Allow"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "*"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "confluent-global"
      priority                                   = 100
      protocol                                   = "Tcp"
      source_address_prefix                      = "10.0.3.0/24"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    }
  ]
  tags                = {}
}

//resource "azurerm_network_security_rule" "confluent" {
//  name                       = "confluent-global"
//  priority                   = 100
//  direction                  = "Inbound"
//  access                     = "Allow"
//  protocol                   = "Tcp"
//  source_port_range          = "*"
//  destination_port_range     = "*"
//  source_address_prefix      = "10.0.3.0/24"
//  destination_address_prefix = "*"
//  resource_group_name        = azurerm_resource_group.confluent.name
//  network_security_group_name = azurerm_network_security_group.private.name
//}

//resource "azurerm_network_security_rule" "ansible" {
//  name                       = "ansible-provision"
//  priority                   = 101
//  direction                  = "Inbound"
//  access                     = "Allow"
//  protocol                   = "Tcp"
//  source_port_range          = "*"
//  destination_port_range     = "*"
//  source_address_prefix      = "10.0.5.0/24"
//  destination_address_prefix = "*"
//  resource_group_name        = azurerm_resource_group.confluent.name
//  network_security_group_name = azurerm_network_security_group.private.name
//}

# Associate network security group with public subnet.
resource azurerm_subnet_network_security_group_association private_subnet_assoc {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private.id
}