# -----------------------------------------------------------------------------
# cert-manager Helm release
# -----------------------------------------------------------------------------
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"

  set = [
    {
      name  = "installCRDs"
      value = "true"
    },
    {
      name  = "replicaCount"
      value = "2"
    }
  ]
}

# -----------------------------------------------------------------------------
# Self-signed ClusterIssuer
# -----------------------------------------------------------------------------
resource "kubernetes_manifest" "selfsigned_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"

    metadata = {
      name = "selfsigned-issuer"
    }

    spec = {
      selfSigned = {}
    }
  }

  depends_on = [helm_release.cert_manager]
}
