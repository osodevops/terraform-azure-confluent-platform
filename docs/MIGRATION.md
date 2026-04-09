# Migration Guide: v1 to v2

## Overview

v2 is a complete rewrite of this module. The architecture changed from **VM-based** (RHEL 7 + Ansible provisioning) to **Kubernetes-native** (AKS + CFK operator).

There is no in-place upgrade path. v1 and v2 use entirely different infrastructure.

## What Changed

| Aspect | v1 | v2 |
|--------|----|----|
| Compute | Azure VMs (RHEL 7) | AKS (Kubernetes) |
| Provisioning | Ansible (cp-ansible) | CFK Operator (Helm) |
| Kafka Mode | ZooKeeper | KRaft (no ZooKeeper) |
| Terraform | 1.0.4 | >= 1.5.0 |
| AzureRM Provider | =3.0.0 | >= 4.0 |
| Confluent Platform | 7.2.1 | 7.7.x+ |
| TLS | None (optional via Ansible) | Enabled by default |
| RBAC | None | Enabled by default (MDS) |
| Access | SSH via Bastion | kubectl / K8s API |

## Migration Strategy

Since v1 and v2 are fundamentally different architectures, the recommended migration is a **blue-green deployment**:

1. **Deploy v2** alongside your existing v1 infrastructure
2. **Migrate data** using one of:
   - Confluent Replicator
   - MirrorMaker 2
   - Consumer/Producer migration (for stateless topics)
3. **Switch clients** to point to the new Kafka bootstrap endpoint
4. **Decommission v1** once all clients have migrated

## State Migration

v1 Terraform state cannot be imported into v2. They manage entirely different resources.

- v1 state: Azure VMs, disks, NICs, NSGs, Bastion, Ansible container
- v2 state: AKS cluster, Helm releases, Kubernetes manifests, Key Vault

## v1 Maintenance

The v1 code is preserved on the `v1` branch. It will receive security patches only. No new features will be added to v1.

## Need Help?

Open an issue on [GitHub](https://github.com/osodevops/terraform-azure-confluent-platform/issues) with the `migration` label.
