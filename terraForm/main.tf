# Define modules for each region
module "region1" {
  source                = "./region"
  region                = "East US"
  resource_group_name   = var.resource_group_name
  storage_account_prefix = var.storage_account_prefix
}

module "region2" {
  source                = "./region"
  region                = "West Europe"
  resource_group_name   = var.resource_group_name
  storage_account_prefix = var.storage_account_prefix
}



