resource "kubectl_manifest" "kafka_rest_proxy" {
  count = var.kafka_rest_proxy.enabled ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "platform.confluent.io/v1beta1"
    kind       = "KafkaRestProxy"
    metadata = {
      name      = "kafkarestproxy"
      namespace = var.namespace
    }
    spec = {
      replicas = var.kafka_rest_proxy.replicas
      image = {
        application = "${local.image_prefix}cp-kafka-rest:${var.confluent_platform_version}"
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
                secretRef = "mds-client-kafkarest"
              }
            }
            tls = {
              enabled = true
            }
          }
        },
        var.schema_registry.enabled ? {
          schemaRegistry = {
            url = "https://schemaregistry.${var.namespace}.svc.cluster.local:8081"
            tls = {
              enabled = true
            }
          }
        } : {},
        var.rbac_enabled ? {
          mds = {
            endpoint = "https://kafka.${var.namespace}.svc.cluster.local:8090"
            tokenKeyPair = {
              secretRef = var.mds_token_secret
            }
            authentication = {
              type = "bearer"
              bearer = {
                secretRef = "mds-client-kafkarest"
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
                app = "kafkarestproxy"
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
