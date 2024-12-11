resource "random_string" "id" {
  length = 5
  upper  = false
  special = false
}

#######################
# Pre-requisites
#######################

module "prerequisites" {
    source = "./modules/prerequisites"
    resource_group_name = format("rg-dd-log-forwarder-%s", random_string.id.result)
    location = var.location
    storage_account_name = format("stddlogforwarder%s", random_string.id.result)
}

########################
# Log Forwarder Setup
########################

# Event hub to collect Azure resource logs
module "eventhub" {
    source = "./modules/event-hub"
    resource_group_name = module.prerequisites.resource_group_name
    location = var.location
    event_hub_namespace_name = format("ehns-dd-log-forwarder-%s", random_string.id.result)
    event_hub_name = format("eh-dd-log-forwarder-%s", random_string.id.result)
}

# Azure functions to forward logs to Datadog
module "function" {
    source = "./modules/function-app"
    resource_group_name = module.prerequisites.resource_group_name
    location = var.location
    app_service_plan_name = format("asp-dd-log-forwarder-%s", random_string.id.result)
    function_app_name = format("fa-dd-log-forwarder-%s", random_string.id.result)
    event_hub_namespace_name = module.eventhub.event_hub_namespace_name
    event_hub_namespace_id = module.eventhub.event_hub_namespace_id
    event_hub_name = module.eventhub.event_hub_name
    datadog_api_key = var.datadog_api_key
    datadog_site = "datadoghq.com"
    storage_account_name = module.prerequisites.storage_account_name
    storage_account_id = module.prerequisites.storage_account_id
}

#########################################
# TODO: Example Usage with Diagnostic Settings
#########################################