# Terraform Azure Datadog Log Forwarder

Terraform code sample to setup Azure resources required to collect and forward Azure resource logs to Datadog instance.

## Reference Architecture

All Datadog Sites (except US3) require an explicit [Azure Integration Setup](https://docs.datadoghq.com/logs/guide/azure-logging-guide/?tab=automatedinstallation) to collect and forward Azure resource logs to Datadog, as shown below.

![](./docs/logforwarding.jpg)

The configuration involves the following steps:

1. Create an Azure Event Hub namespace and an Event Hub Topic to collect resource logs
2. Create a Datadog Azure function with an Event Hub trigger to forward logs to Datadog whenever an event occurs
3. Configure the Diagnostic Settings in Azure Resources and/or Azure Monitor to send both resource logs and activity logs to the Event Hub Topic

This repository provides the Terraform code to create and configure the above resources with Vnet Integrtaion.

## Getting Started

### Prerequisites

- Hashicorp Terraform - [Download](https://developer.hashicorp.com/terraform/install)
- Azure CLI - [Download](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows)
- Azure Subscription - [Free Account](https://azure.microsoft.com/en-gb/pricing/purchase-options/azure-account/search?icid=free-search)

### Setup

- TODO: Add setup instructions
