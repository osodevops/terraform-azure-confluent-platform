# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - Unreleased

### Changed
- **BREAKING**: Complete rewrite from VM-based (Ansible) to AKS + CFK (Confluent for Kubernetes) architecture
- **BREAKING**: Minimum Terraform version raised to >= 1.5.0
- **BREAKING**: AzureRM provider updated to >= 4.0
- **BREAKING**: All variables, outputs, and module structure redesigned

### Added
- AKS cluster provisioning with private cluster, workload identity, and multi-AZ node pools
- Confluent for Kubernetes (CFK) operator 3.x deployment via Helm
- KRaft mode (ZooKeeper removed) for Kafka controllers
- All Confluent Platform components as Kubernetes custom resources (Kafka, Schema Registry, Connect, ksqlDB, Control Center, REST Proxy)
- Production-grade security: TLS/mTLS, RBAC with MDS, Azure Managed Identities, network policies
- Azure Key Vault integration for secrets management
- cert-manager for TLS certificate lifecycle
- Prometheus ServiceMonitor and Grafana dashboard support
- Terraform native tests (`.tftest.hcl`)
- Pre-commit hooks configuration
- Security scanning in CI (trivy, tfsec)
- terraform-docs based documentation generation
- Multiple examples: complete, minimal, bring-your-own-aks
- Migration guide from v1

### Removed
- VM-based Confluent node modules (`confluent_node`, `confluent_node_public`)
- Ansible-based provisioning (`cp-ansible` container)
- Azure Bastion host
- SSH key generation scripts
- build-harness dependency
- ZooKeeper (replaced by KRaft)

## [1.0.0] - 2024-01-01

### Note
v1.x deployed Confluent Platform 7.2.1 on RHEL 7 VMs using Ansible provisioning.
The v1 code is preserved on the `v1` branch for existing users.
See [Migration Guide](docs/MIGRATION.md) for upgrading from v1 to v2.
