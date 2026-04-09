provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = module.confluent_platform.kube_config != null ? yamldecode(module.confluent_platform.kube_config).clusters[0].cluster.server : ""
    client_certificate     = module.confluent_platform.kube_config != null ? base64decode(yamldecode(module.confluent_platform.kube_config).users[0].user.client-certificate-data) : ""
    client_key             = module.confluent_platform.kube_config != null ? base64decode(yamldecode(module.confluent_platform.kube_config).users[0].user.client-key-data) : ""
    cluster_ca_certificate = module.confluent_platform.kube_config != null ? base64decode(yamldecode(module.confluent_platform.kube_config).clusters[0].cluster.certificate-authority-data) : ""
  }
}

provider "kubernetes" {
  host                   = module.confluent_platform.kube_config != null ? yamldecode(module.confluent_platform.kube_config).clusters[0].cluster.server : ""
  client_certificate     = module.confluent_platform.kube_config != null ? base64decode(yamldecode(module.confluent_platform.kube_config).users[0].user.client-certificate-data) : ""
  client_key             = module.confluent_platform.kube_config != null ? base64decode(yamldecode(module.confluent_platform.kube_config).users[0].user.client-key-data) : ""
  cluster_ca_certificate = module.confluent_platform.kube_config != null ? base64decode(yamldecode(module.confluent_platform.kube_config).clusters[0].cluster.certificate-authority-data) : ""
}

provider "kubectl" {
  host                   = module.confluent_platform.kube_config != null ? yamldecode(module.confluent_platform.kube_config).clusters[0].cluster.server : ""
  client_certificate     = module.confluent_platform.kube_config != null ? base64decode(yamldecode(module.confluent_platform.kube_config).users[0].user.client-certificate-data) : ""
  client_key             = module.confluent_platform.kube_config != null ? base64decode(yamldecode(module.confluent_platform.kube_config).users[0].user.client-key-data) : ""
  cluster_ca_certificate = module.confluent_platform.kube_config != null ? base64decode(yamldecode(module.confluent_platform.kube_config).clusters[0].cluster.certificate-authority-data) : ""
  load_config_file       = false
}
