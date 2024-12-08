# Pre-requisites
module "prerequisites" {
    source = "./prerequisites"
    resource_group_name = var.resource_group_name
    location = var.location
    storage_account_name = "stdatadoglogforwarder001"
}

# Event hub to collect Azure resource logs
module "eventhub" {
    source = "./event-hub"
    resource_group_name = var.resource_group_name
    location = var.location
    event_hub_namespace_name = "ehns-datadog-log-forwarder-001"
    event_hub_name = "eh-datadog-log-forwarder-001"
}

# Azure functions to forward logs to Datadog
module "function" {
    source = "./function-app"
    resource_group_name = var.resource_group_name
    location = var.location
    app_service_plan_name = "asp-datadog-log-forwarder-001"
    function_app_name = "fa-datadog-log-forwarder-001"
    event_hub_namespace_name = module.eventhub.event_hub_namespace_name
    event_hub_namespace_id = module.eventhub.event_hub_namespace_id
    event_hub_name = module.eventhub.event_hub_name
    datadog_api_key = var.datadog_api_key
    datadog_site = "datadoghq.com"
    storage_account_name = module.prerequisites.storage_account_name
    storage_account_id = module.prerequisites.storage_account_id
}
