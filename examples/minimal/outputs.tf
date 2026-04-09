output "kafka_bootstrap_endpoint" {
  description = "Kafka bootstrap endpoint."
  value       = module.confluent_platform.kafka_bootstrap_endpoint
}
