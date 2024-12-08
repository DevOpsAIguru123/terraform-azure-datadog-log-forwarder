# Terraform Azure Datadog Log Forwarder

Terraform code to setup Azure resources (Azure functions, Eventhub, etc) to collect and forward logs to Datadog.

- The reference architecture to send Azure resource logs to Datadog is given [here](https://docs.datadoghq.com/integrations/guide/azure-architecture-and-configuration/#standard-azure-integration-log-collection).
- Steps to setup this architecture both manually and with Powershell automation scripts is given [here](https://docs.datadoghq.com/logs/guide/azure-logging-guide/?tab=automatedinstallation).

This repository aims to provide Terraform code to deploy this log forwarder setup. A resource group will be created with the following setup:
1. Azure Event Hub Namespace and Topic to collect resource logs
2. Azure Function app and a log forwarder function with event hub trigger to forward logs to Datadog
3. Vnet integration for all the resources
4. Example resource with Diagnostic setting enabled to send logs to Event Hub topic
