resource "azurerm_private_dns_zone" "internal" {
  name                = "confluent.internal"
  resource_group_name = azurerm_resource_group.confluent.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "confluent-internal"
  resource_group_name   = azurerm_resource_group.confluent.name
  private_dns_zone_name = azurerm_private_dns_zone.internal.name
  virtual_network_id    = azurerm_virtual_network.confluent.id
}