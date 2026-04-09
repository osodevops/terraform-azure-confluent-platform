############################
# Kafka ServiceMonitor (always created)
############################
resource "kubectl_manifest" "kafka_service_monitor" {
  yaml_body = <<-YAML
    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      name: kafka
      namespace: ${var.prometheus_namespace}
      labels:
        app: kafka
        release: prometheus
    spec:
      namespaceSelector:
        matchNames:
          - ${var.confluent_namespace}
      selector:
        matchLabels:
          app: kafka
      endpoints:
        - port: prometheus
          interval: 30s
          path: /metrics
  YAML
}

############################
# KRaft Controller ServiceMonitor (always created)
############################
resource "kubectl_manifest" "kraftcontroller_service_monitor" {
  yaml_body = <<-YAML
    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      name: kraftcontroller
      namespace: ${var.prometheus_namespace}
      labels:
        app: kraftcontroller
        release: prometheus
    spec:
      namespaceSelector:
        matchNames:
          - ${var.confluent_namespace}
      selector:
        matchLabels:
          app: kraftcontroller
      endpoints:
        - port: prometheus
          interval: 30s
          path: /metrics
  YAML
}

############################
# Schema Registry ServiceMonitor (conditional)
############################
resource "kubectl_manifest" "schemaregistry_service_monitor" {
  count = var.component_flags["schema_registry"] ? 1 : 0

  yaml_body = <<-YAML
    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      name: schemaregistry
      namespace: ${var.prometheus_namespace}
      labels:
        app: schemaregistry
        release: prometheus
    spec:
      namespaceSelector:
        matchNames:
          - ${var.confluent_namespace}
      selector:
        matchLabels:
          app: schemaregistry
      endpoints:
        - port: prometheus
          interval: 30s
          path: /metrics
  YAML
}

############################
# Connect ServiceMonitor (conditional)
############################
resource "kubectl_manifest" "connect_service_monitor" {
  count = var.component_flags["connect"] ? 1 : 0

  yaml_body = <<-YAML
    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      name: connect
      namespace: ${var.prometheus_namespace}
      labels:
        app: connect
        release: prometheus
    spec:
      namespaceSelector:
        matchNames:
          - ${var.confluent_namespace}
      selector:
        matchLabels:
          app: connect
      endpoints:
        - port: prometheus
          interval: 30s
          path: /metrics
  YAML
}

############################
# ksqlDB ServiceMonitor (conditional)
############################
resource "kubectl_manifest" "ksqldb_service_monitor" {
  count = var.component_flags["ksqldb"] ? 1 : 0

  yaml_body = <<-YAML
    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      name: ksqldb
      namespace: ${var.prometheus_namespace}
      labels:
        app: ksqldb
        release: prometheus
    spec:
      namespaceSelector:
        matchNames:
          - ${var.confluent_namespace}
      selector:
        matchLabels:
          app: ksqldb
      endpoints:
        - port: prometheus
          interval: 30s
          path: /metrics
  YAML
}

############################
# Control Center ServiceMonitor (conditional)
############################
resource "kubectl_manifest" "controlcenter_service_monitor" {
  count = var.component_flags["control_center"] ? 1 : 0

  yaml_body = <<-YAML
    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      name: controlcenter
      namespace: ${var.prometheus_namespace}
      labels:
        app: controlcenter
        release: prometheus
    spec:
      namespaceSelector:
        matchNames:
          - ${var.confluent_namespace}
      selector:
        matchLabels:
          app: controlcenter
      endpoints:
        - port: prometheus
          interval: 30s
          path: /metrics
  YAML
}

############################
# Kafka REST Proxy ServiceMonitor (conditional)
############################
resource "kubectl_manifest" "kafkarestproxy_service_monitor" {
  count = var.component_flags["kafka_rest_proxy"] ? 1 : 0

  yaml_body = <<-YAML
    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      name: kafkarestproxy
      namespace: ${var.prometheus_namespace}
      labels:
        app: kafkarestproxy
        release: prometheus
    spec:
      namespaceSelector:
        matchNames:
          - ${var.confluent_namespace}
      selector:
        matchLabels:
          app: kafkarestproxy
      endpoints:
        - port: prometheus
          interval: 30s
          path: /metrics
  YAML
}
