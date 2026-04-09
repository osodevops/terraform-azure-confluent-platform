resource "kubectl_manifest" "schema_registry" {
  count = var.schema_registry.enabled ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "platform.confluent.io/v1beta1"
    kind       = "SchemaRegistry"
    metadata = {
      name      = "schemaregistry"
      namespace = var.namespace
    }
    spec = {
      replicas = var.schema_registry.replicas
      image = {
        application = "${local.image_prefix}cp-schema-registry:${var.confluent_platform_version}"
        init        = "${local.image_prefix}confluent-init-container:${var.confluent_platform_version}"
      }
      tls = local.tls_config
      dependencies = merge(
        {
          kafka = {
            bootstrapEndpoint = "kafka.${var.namespace}.svc.cluster.local:9071"
            authentication = {
              type = "plain"
              jaasConfig = {
                secretRef = "mds-client-sr"
              }
            }
            tls = {
              enabled = true
            }
          }
        },
        var.rbac_enabled ? {
          mds = {
            endpoint = "https://kafka.${var.namespace}.svc.cluster.local:8090"
            tokenKeyPair = {
              secretRef = var.mds_token_secret
            }
            authentication = {
              type = "bearer"
              bearer = {
                secretRef = "mds-client-sr"
              }
            }
          }
        } : {}
      )
      podTemplate = {
        topologySpreadConstraints = [
          {
            maxSkew           = 1
            topologyKey       = "topology.kubernetes.io/zone"
            whenUnsatisfiable = "DoNotSchedule"
            labelSelector = {
              matchLabels = {
                app = "schemaregistry"
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
    }
  })

  depends_on = [kubectl_manifest.kafka]
}
