resource "helm_release" "confluent_operator" {
  name             = "confluent-operator"
  repository       = "https://packages.confluent.io/helm"
  chart            = "confluent-for-kubernetes"
  version          = var.operator_version
  namespace        = var.namespace
  create_namespace = var.create_namespace
  wait             = true
  timeout          = 600

  set = [
    {
      name  = "namespaced"
      value = tostring(var.namespaced)
    },
    {
      name  = "resources.requests.cpu"
      value = var.resource_requests.cpu
    },
    {
      name  = "resources.requests.memory"
      value = var.resource_requests.memory
    },
    {
      name  = "resources.limits.cpu"
      value = var.resource_limits.cpu
    },
    {
      name  = "resources.limits.memory"
      value = var.resource_limits.memory
    }
  ]
}
