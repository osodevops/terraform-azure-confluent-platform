resource "kubectl_manifest" "control_center" {
  count = var.control_center.enabled ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "platform.confluent.io/v1beta1"
    kind       = "ControlCenter"
    metadata = {
      name      = "controlcenter"
      namespace = var.namespace
    }
    spec = {
      replicas = var.control_center.replicas
      image = {
        application = "${local.image_prefix}cp-enterprise-control-center:${var.confluent_platform_version}"
        init        = "${local.image_prefix}confluent-init-container:${var.confluent_platform_version}"
      }
      dataVolumeCapacity = var.control_center.storage_size
      storageClass = {
        name = var.control_center.storage_class
      }
      tls = local.tls_config
      dependencies = merge(
        {
          kafka = {
            bootstrapEndpoint = "kafka.${var.namespace}.svc.cluster.local:9071"
            authentication = {
              type = "plain"
              jaasConfig = {
                secretRef = "mds-client-c3"
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
        var.connect.enabled ? {
          connect = [{
            url = "https://connect.${var.namespace}.svc.cluster.local:8083"
            tls = {
              enabled = true
            }
          }]
        } : {},
        var.ksqldb.enabled ? {
          ksqldb = [{
            url = "https://ksqldb.${var.namespace}.svc.cluster.local:8088"
            tls = {
              enabled = true
            }
          }]
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
                secretRef = "mds-client-c3"
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
                app = "controlcenter"
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
