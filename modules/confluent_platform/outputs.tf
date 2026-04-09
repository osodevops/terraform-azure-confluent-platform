output "kafka_bootstrap_endpoint" {
  description = "The internal bootstrap endpoint for the Kafka cluster."
  value       = "kafka.${var.namespace}.svc.cluster.local:9071"
}

output "schema_registry_endpoint" {
  description = "The internal endpoint for Schema Registry."
  value       = var.schema_registry.enabled ? "https://schemaregistry.${var.namespace}.svc.cluster.local:8081" : null
}

output "connect_endpoint" {
  description = "The internal endpoint for Kafka Connect."
  value       = var.connect.enabled ? "https://connect.${var.namespace}.svc.cluster.local:8083" : null
}

output "ksqldb_endpoint" {
  description = "The internal endpoint for ksqlDB."
  value       = var.ksqldb.enabled ? "https://ksqldb.${var.namespace}.svc.cluster.local:8088" : null
}

output "control_center_endpoint" {
  description = "The internal endpoint for Confluent Control Center."
  value       = var.control_center.enabled ? "https://controlcenter.${var.namespace}.svc.cluster.local:9021" : null
}

output "kafka_rest_proxy_endpoint" {
  description = "The internal endpoint for the Kafka REST Proxy."
  value       = var.kafka_rest_proxy.enabled ? "https://kafkarestproxy.${var.namespace}.svc.cluster.local:8082" : null
}
