#TODO: Template out these CIDR ranges
resource azurerm_subnet container {
  name                 = "container-deployments"
  virtual_network_name = azurerm_virtual_network.confluent.name
  resource_group_name  = azurerm_resource_group.confluent.name
  address_prefixes     = ["10.0.5.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource azurerm_network_profile cp-ansible {
  name                = "cp-ansible-networkprofile"
  location            = azurerm_resource_group.confluent.location
  resource_group_name = azurerm_resource_group.confluent.name

  container_network_interface {
    name = "hellocnic"

    ip_configuration {
      name      = "helloipconfig"
      subnet_id = azurerm_subnet.container.id
    }
  }
}

resource azurerm_container_group ansible {
  name                = "oso-devops-cp-ansible"
  location            = azurerm_resource_group.confluent.location
  resource_group_name = azurerm_resource_group.confluent.name
  ip_address_type     = "Private"
  network_profile_id  = azurerm_network_profile.cp-ansible.id
  os_type             = "Linux"
  restart_policy      = "Never"

  container {
    name   = "cp-ansible"
    image  = "osodevops/cp-ansible:${var.cp_ansible_version}"
    cpu    = "0.5"
    memory = "1.5"
    // Uncomment this to exec onto container for debug purposes
    // commands = ["sleep", "100000"]

    ports {
      port     = 443
      protocol = "TCP"
    }

    volume {
      name       = "ssh"
      mount_path = "/root/staging"
      read_only  = false
      share_name = azurerm_storage_share.ssh.name
      storage_account_name = azurerm_storage_account.cp-ansible.name
      storage_account_key  = azurerm_storage_account.cp-ansible.primary_access_key
    }
  }
}

resource azurerm_storage_account cp-ansible {
  name                     = "cpansible"
  resource_group_name      = azurerm_resource_group.confluent.name
  location                 = azurerm_resource_group.confluent.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource azurerm_storage_container ssh-container {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.cp-ansible.name
  container_access_type = "private"
}

resource azurerm_storage_share ssh {
  name                 = "ansible-ssh"
  storage_account_name = azurerm_storage_account.cp-ansible.name
  quota                = 50

  acl {
    id = "ansible-ssh-access"
    access_policy {
      permissions = "r"
    }
  }
}

resource azurerm_storage_share_file ansible-inventory {
  name             = "ansible-inventory.yml"
  storage_share_id = azurerm_storage_share.ssh.id
//  content_md5      = md5(file("${path.module}/ansible-inventory.yml"))
  source           = "${path.module}/ansible-inventory.yml"
//  metadata         = {}
}

resource azurerm_storage_share_file ssh-priv-key {
  name             = "id_rsa"
  storage_share_id = azurerm_storage_share.ssh.id
  source           = "${path.module}/oso-confluent-ssh.pem"
}