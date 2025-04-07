# Log Analytics Workspace for Application Insights
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "law-${var.function_app_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  
  # If this resource already exists, import it using:
  # terraform import module.function.azurerm_log_analytics_workspace.log_analytics /subscriptions/60992dbe-c574-4373-948b-bb02216c5b0a/resourceGroups/rg-dd-log-forwarder-jzbku/providers/Microsoft.OperationalInsights/workspaces/law-fa-dd-log-forwarder-jzbku
  
  timeouts {
    create = "30m"
    read = "10m"
  }
}

# Application Insights for monitoring the Function App
resource "azurerm_application_insights" "app_insights" {
  name                = "appi-${var.function_app_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics.id
  application_type    = "web"
  
  depends_on = [azurerm_log_analytics_workspace.log_analytics]
  
  timeouts {
    create = "30m"
    read = "10m"
  }
}

# Output the instrumentation key and connection string for use in function app settings
output "app_insights_instrumentation_key" {
  value     = azurerm_application_insights.app_insights.instrumentation_key
  sensitive = true
}

output "app_insights_connection_string" {
  value     = azurerm_application_insights.app_insights.connection_string
  sensitive = true
}
