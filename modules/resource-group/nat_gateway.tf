resource "azurerm_public_ip" "nat" {
  name                = "nat-gateway-publicIP"
  location            = azurerm_resource_group.confluent.location
  resource_group_name = azurerm_resource_group.confluent.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "nat" {
  name                = "confluent-NatGateway"
  location            = azurerm_resource_group.confluent.location
  resource_group_name = azurerm_resource_group.confluent.name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "containers" {
  subnet_id      = azurerm_subnet.container.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "internal" {
  subnet_id      = azurerm_subnet.confluent.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}