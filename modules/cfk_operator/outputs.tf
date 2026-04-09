output "operator_release_name" {
  value       = helm_release.confluent_operator.name
  description = "The name of the Helm release for the CFK operator"
}

output "operator_namespace" {
  value       = helm_release.confluent_operator.namespace
  description = "The namespace the CFK operator is deployed into"
}

output "operator_version" {
  value       = helm_release.confluent_operator.version
  description = "The Helm chart version of the CFK operator"
}

output "operator_status" {
  value       = helm_release.confluent_operator.status
  description = "The status of the CFK operator Helm release"
}
