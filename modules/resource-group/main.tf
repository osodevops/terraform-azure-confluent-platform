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



// For Bastion Use

resource "azurerm_virtual_network" "bastion" {
  name                = "bastionvnet"
  address_space       = ["10.0.2.0/24"]
  location            = azurerm_resource_group.confluent.location
  resource_group_name = azurerm_resource_group.confluent.name
}

resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.confluent.name
  virtual_network_name = azurerm_virtual_network.confluent.name
  address_prefixes     = ["10.0.2.224/27"]
}

resource "azurerm_public_ip" "bastion-ip" {
  name                = "bastionIP"
  location            = azurerm_resource_group.confluent.location
  resource_group_name = azurerm_resource_group.confluent.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "example" {
  name                = "confluent-bastion"
  location            = azurerm_resource_group.confluent.location
  resource_group_name = azurerm_resource_group.confluent.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-ip.id
  }
}