locals {
  prefix = "oso"
  environment = "${basename(get_terragrunt_dir())}"
  internal_subnet_name = "internal"
  azure_location = "UK South"
  common_tags = {
    "Application" = "confluent"
    "Environment" = "production"
    "Parent Business" = "Shared IT core services",
    "Portfolio" = "Digital and Technology",
    "Service Offering" = "Enterprise Data Integration Service",
    "Service Line" = "Cloud Infrastructure and Platforms",
    "Service" = "Azure Storage"
    "Product" = "Enterprise Data Integration Service"
  }
}
