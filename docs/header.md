# Confluent Platform on Azure (AKS + CFK)

Terraform module for deploying a production-grade [Confluent Platform](https://www.confluent.io/product/confluent-platform/) on [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service) using the [Confluent for Kubernetes (CFK)](https://docs.confluent.io/operator/current/overview.html) operator.

## Features

- **Private AKS cluster** with multi-AZ node pools and workload identity
- **KRaft mode** (no ZooKeeper dependency)
- **All Confluent components**: Kafka, Schema Registry, Connect, ksqlDB, Control Center, REST Proxy
- **Production security**: TLS/mTLS, RBAC with MDS, Azure Managed Identities
- **Monitoring**: Prometheus ServiceMonitors and Grafana dashboards
- **Flexible**: bring-your-own VNet/AKS, toggle components on/off

## Architecture

```text
Azure Resource Group
├── VNet (10.0.0.0/16)
│   ├── AKS Node Subnet (/21)
│   ├── Internal LB Subnet (/24)
│   └── Private Endpoint Subnet (/24)
├── NAT Gateway
├── Private DNS Zones
├── Azure Key Vault
└── Private AKS Cluster
    ├── System Node Pool (3 nodes, 3 AZs)
    └── Confluent Node Pool (3+ nodes, 3 AZs)
        ├── KRaft Controllers (3 replicas)
        ├── Kafka Brokers (3+ replicas)
        ├── Schema Registry
        ├── Connect (optional)
        ├── ksqlDB (optional)
        ├── Control Center
        └── REST Proxy (optional)
```

## Quick Start

```hcl
module "confluent_platform" {
  source  = "osodevops/confluent-platform/azure"
  version = "~> 2.0"

  name        = "my-confluent"
  environment = "production"
  location    = "uksouth"
}
```

See [examples/](examples/) for more usage patterns.

## Migration from v1

This is v2 of the module - a complete rewrite from VM-based (Ansible) to AKS + CFK.
See [Migration Guide](docs/MIGRATION.md) for upgrading from v1.
