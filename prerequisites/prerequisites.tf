# Resource group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

# Storage account
resource "azurerm_storage_account" "storage_account" {
  name = var.storage_account_name
  resource_group_name = var.resource_group_name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}
