resource "kubectl_manifest" "kraft_controller" {
  yaml_body = yamlencode({
    apiVersion = "platform.confluent.io/v1beta1"
    kind       = "KRaftController"
    metadata = {
      name      = "kraftcontroller"
      namespace = var.namespace
    }
    spec = {
      replicas = var.kraft_controller.replicas
      image = {
        application = "${local.image_prefix}cp-server:${var.confluent_platform_version}"
        init        = "${local.image_prefix}confluent-init-container:${var.confluent_platform_version}"
      }
      dataVolumeCapacity = var.kraft_controller.storage_size
      storageClass = {
        name = var.kraft_controller.storage_class
      }
      tls = local.tls_config
      podTemplate = {
        topologySpreadConstraints = [
          {
            maxSkew           = 1
            topologyKey       = "topology.kubernetes.io/zone"
            whenUnsatisfiable = "DoNotSchedule"
            labelSelector = {
              matchLabels = {
                app = "kraftcontroller"
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
}
