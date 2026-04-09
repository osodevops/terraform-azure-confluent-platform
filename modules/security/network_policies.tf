# -----------------------------------------------------------------------------
# Default deny all ingress in the Confluent namespace
# -----------------------------------------------------------------------------
resource "kubernetes_network_policy_v1" "default_deny" {
  metadata {
    name      = "default-deny-ingress"
    namespace = kubernetes_namespace_v1.confluent.metadata[0].name
  }

  spec {
    pod_selector {}

    policy_types = ["Ingress"]
  }
}

# -----------------------------------------------------------------------------
# Allow all traffic between pods within the Confluent namespace
# -----------------------------------------------------------------------------
resource "kubernetes_network_policy_v1" "allow_confluent_internal" {
  metadata {
    name      = "allow-confluent-internal"
    namespace = kubernetes_namespace_v1.confluent.metadata[0].name
  }

  spec {
    pod_selector {}

    ingress {
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = kubernetes_namespace_v1.confluent.metadata[0].name
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}
