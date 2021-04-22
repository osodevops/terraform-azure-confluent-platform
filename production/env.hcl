locals {
  prefix = "oso"
  environment = "${basename(get_terragrunt_dir())}"
  private_subnet_name = "confluent-private"
  public_subnet_name = "confluent-public"
  azure_location = "UK South"
  dns_zone = "confluent.internal"
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
