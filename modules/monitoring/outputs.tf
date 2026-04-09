output "service_monitor_names" {
  description = "List of all created Prometheus ServiceMonitor names."
  value = compact(concat(
    ["kafka", "kraftcontroller"],
    var.component_flags["schema_registry"] ? ["schemaregistry"] : [],
    var.component_flags["connect"] ? ["connect"] : [],
    var.component_flags["ksqldb"] ? ["ksqldb"] : [],
    var.component_flags["control_center"] ? ["controlcenter"] : [],
    var.component_flags["kafka_rest_proxy"] ? ["kafkarestproxy"] : [],
  ))
}
