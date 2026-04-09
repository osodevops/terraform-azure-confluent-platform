output "aks_cluster_name" {
  description = "AKS cluster name."
  value       = module.confluent_platform.aks_cluster_name
}

output "kafka_bootstrap_endpoint" {
  description = "Kafka bootstrap endpoint."
  value       = module.confluent_platform.kafka_bootstrap_endpoint
}

output "schema_registry_endpoint" {
  description = "Schema Registry endpoint."
  value       = module.confluent_platform.schema_registry_endpoint
}

output "control_center_endpoint" {
  description = "Control Center endpoint."
  value       = module.confluent_platform.control_center_endpoint
}
