module "resource-group" {
  source = "../modules/resource-group"
  prefix = var.prefix
  environment = var.environment
  location = var.azure_location
  private_subnet_name = var.private_subnet_name
  public_subnet_name = var.public_subnet_name
}