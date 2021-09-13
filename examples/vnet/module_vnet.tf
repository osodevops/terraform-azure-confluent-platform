resource "azurerm_resource_group" "vnet_resources" {
  name     = var.project_name
  location = var.location
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  vnet_name           = var.project_name
  resource_group_name = azurerm_resource_group.vnet_resources.name
  address_space       = ["20.0.0.0/16"]
  subnet_prefixes     = ["20.0.1.0/24", "20.0.2.0/24", "20.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    subnet2 = ["Microsoft.AzureActiveDirectory","Microsoft.Storage", "Microsoft.ContainerRegistry"],
    subnet3 = ["Microsoft.AzureActiveDirectory", "Microsoft.Storage", "Microsoft.ContainerRegistry"]
  }

  route_tables_ids = {
    subnet1 = azurerm_route_table.example.id
    subnet2 = azurerm_route_table.example.id
    subnet3 = azurerm_route_table.example.id
  }

  subnet_enforce_private_link_endpoint_network_policies = {
    "subnet2" = true,
    "subnet3" = true
  }

  tags = {
    environment = "prod"
  }

  depends_on = [azurerm_resource_group.vnet_resources]
}

resource "azurerm_route_table" "example" {
  name                = "${var.project_name}-route-table"
  resource_group_name = azurerm_resource_group.vnet_resources.name
  location            = azurerm_resource_group.vnet_resources.location
}

resource "azurerm_route" "example" {
  name                = "${var.project_name}-acceptance-route-1"
  resource_group_name = azurerm_resource_group.vnet_resources.name
  route_table_name    = azurerm_route_table.example.name
  address_prefix      = "10.1.0.0/16"
  next_hop_type       = "vnetlocal"
}