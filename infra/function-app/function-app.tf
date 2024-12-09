#######################
# Create Function App #
#######################

# App service plan
resource "azurerm_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Windows"
  sku_name            = "EP1"
}

# Function app
resource "azurerm_windows_function_app" "function_app" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"                    = "1",
    "FUNCTIONS_WORKER_RUNTIME"                    = "node",
    "AzureWebJobsDisableHomepage"                 = "true",
    "WEBSITE_NODE_DEFAULT_VERSION"                = "~18",
    "EventHubConnection__credential"              = "managedidentity",
    "EventHubConnection__fullyQualifiedNamespace" = format("%s.servicebus.windows.net", var.event_hub_namespace_name),
    "DD_API_KEY"                                  = var.datadog_api_key,
    "DD_SITE"                                     = var.datadog_site
  }
  site_config {}
  storage_account_name          = var.storage_account_name
  storage_uses_managed_identity = true
  identity {
    type = "SystemAssigned"
  }
}

# Role Assignment for storage account - https://learn.microsoft.com/en-us/azure/azure-functions/functions-reference?tabs=eventhubs&pivots=programming-language-javascript#connecting-to-host-storage-with-an-identity
resource "azurerm_role_assignment" "role_assignment_storage" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_windows_function_app.function_app.identity[0].principal_id
}

# Role Assignment for event hub - https://learn.microsoft.com/en-us/azure/azure-functions/functions-reference?tabs=eventhubs&pivots=programming-language-javascript#grant-permission-to-the-identity
resource "azurerm_role_assignment" "role_assignment_event_hub" {
  scope                = var.event_hub_namespace_id
  role_definition_name = "Azure Event Hubs Data Owner"
  principal_id         = azurerm_windows_function_app.function_app.identity[0].principal_id
}

#######################
# Zip Deploy Function #
#######################

locals {
  function_json = templatefile("${path.module}/functions/dd-log-forwarder/function.json", { event_hub_name = var.event_hub_name })
  index_js      = file("${path.module}/functions/dd-log-forwarder/index.js")
  host_json     = file("${path.module}/functions/host.json")
}

# Create zip folder with functions
data "archive_file" "functions_zip" {
  type        = "zip"
  output_path = "${path.module}/functions.zip"
  source {
    content  = local.function_json
    filename = "dd-log-forwarder/function.json"
  }
  source {
    content  = local.index_js
    filename = "dd-log-forwarder/index.js"
  }
  source {
    content  = local.host_json
    filename = "host.json"
  }
}

# Publish code to function app
locals {
  publish_code_command        = "az webapp deploy --resource-group ${var.resource_group_name} --name ${azurerm_windows_function_app.function_app.name} --src-path ${data.archive_file.functions_zip.output_path}"
}

resource "null_resource" "function_app_publish" {
  depends_on = [local.publish_code_command, azurerm_role_assignment.role_assignment_storage, azurerm_role_assignment.role_assignment_event_hub]
  triggers = {
    input_json                  = filemd5(data.archive_file.functions_zip.output_path)
    publish_code_command        = local.publish_code_command
  }
  provisioner "local-exec" {
    command = local.publish_code_command
  }
}
