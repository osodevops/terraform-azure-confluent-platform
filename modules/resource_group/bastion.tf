resource azurerm_virtual_network bastion {
  name                = "bastionvnet"
  address_space       = ["10.0.2.0/24"]
  location            = azurerm_resource_group.confluent.location
  resource_group_name = azurerm_resource_group.confluent.name
  tags                = {}
}

resource azurerm_subnet bastion-subnet {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.confluent.name
  virtual_network_name = azurerm_virtual_network.confluent.name
  address_prefixes     = ["10.0.2.224/27"]
}

resource azurerm_public_ip bastion-ip {
  name                = "bastionIP"
  location            = azurerm_resource_group.confluent.location
  resource_group_name = azurerm_resource_group.confluent.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                    = {}
  zones                   = []
}

resource azurerm_bastion_host example {
  name                = "confluent-bastion"
  location            = azurerm_resource_group.confluent.location
  resource_group_name = azurerm_resource_group.confluent.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-ip.id
  }
}