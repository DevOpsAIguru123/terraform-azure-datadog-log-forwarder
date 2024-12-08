# Event Hub Namespace
resource "azurerm_eventhub_namespace" "eventhub-namespace" {
  name                          = var.event_hub_namespace_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = "Standard"
  capacity                      = 2
}

# Event hub topic
resource "azurerm_eventhub" "eventhub" {
  name                = var.event_hub_name
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 7
}

