resource "kubectl_manifest" "kafka" {
  yaml_body = yamlencode({
    apiVersion = "platform.confluent.io/v1beta1"
    kind       = "Kafka"
    metadata = {
      name      = "kafka"
      namespace = var.namespace
    }
    spec = merge(
      {
        replicas = var.kafka.replicas
        image = {
          application = "${local.image_prefix}cp-server:${var.confluent_platform_version}"
          init        = "${local.image_prefix}confluent-init-container:${var.confluent_platform_version}"
        }
        dataVolumeCapacity = var.kafka.storage_size
        storageClass = {
          name = var.kafka.storage_class
        }
        tls = local.tls_config
        listeners = {
          internal = {
            authentication = {
              type = "plain"
              jaasConfig = {
                secretRef = "mds-client-kafka"
              }
            }
            tls = {
              enabled = true
            }
          }
          external = {
            authentication = {
              type = "plain"
              jaasConfig = {
                secretRef = "mds-client-kafka"
              }
            }
            tls = {
              enabled = true
            }
          }
        }
        dependencies = {
          kRaftController = {
            clusterRef = {
              name = "kraftcontroller"
            }
          }
        }
        podTemplate = {
          topologySpreadConstraints = [
            {
              maxSkew           = 1
              topologyKey       = "topology.kubernetes.io/zone"
              whenUnsatisfiable = "DoNotSchedule"
              labelSelector = {
                matchLabels = {
                  app = "kafka"
                }
              }
            }
          ]
          tolerations = [
            {
              key      = "confluent.io/workload"
              operator = "Equal"
              value    = "true"
              effect   = "NoSchedule"
            }
          ]
        }
        metrics = {
          prometheus = {
            blacklist = []
            rules     = []
          }
        }
      },
      var.rbac_enabled ? {
        authorization = {
          type       = "rbac"
          superUsers = var.mds_super_users
        }
        services = {
          mds = {
            tls = {
              enabled = true
            }
            tokenKeyPair = {
              secretRef = var.mds_token_secret
            }
          }
        }
      } : {}
    )
  })

  depends_on = [kubectl_manifest.kraft_controller]
}
