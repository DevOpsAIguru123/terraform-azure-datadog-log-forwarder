# Terraform Azure Datadog Log Forwarder :scroll:

Terraform code sample to setup Azure resources required to collect and forward Azure resource logs to Datadog instance.

## Reference Architecture :bulb:

Most Datadog sites (excluding US3) require a dedicated [Azure integration setup](https://docs.datadoghq.com/logs/guide/azure-logging-guide/?tab=automatedinstallation) to collect and forward Azure resource logs to Datadog. Below is an illustration of the architecture:

![](./docs/logforwarding.jpg)

### Key Components :pushpin:

The configuration involves the following steps:

#### 1. Event Hub Setup

Create an Azure Event Hub namespace and an Event Hub topic to collect resource logs.

#### 2. Datadog Integration

Deploy a Datadog Azure Function with an Event Hub trigger. This function ensures logs are forwarded to Datadog in real time whenever events occur.

#### 3. Diagnostic Settings

Configure Azure Resources and/or Azure Monitor to send both resource and activity logs to the Event Hub topic via Diagnostic Settings.

### Terraform Implementation :computer:

This repository provides Terraform code to automate the creation and configuration of these resources, complete with VNet integration for enhanced security and network performance.

## Getting Started :rocket:

### Prerequisites :page_with_curl:

- Hashicorp Terraform - [Download](https://developer.hashicorp.com/terraform/install)
- Azure CLI - [Download](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows)
- Ensure you have access to an active Azure subscription. If you don’t have one, you can sign up for a [free Azure account](https://azure.microsoft.com/en-gb/pricing/purchase-options/azure-account/search?icid=free-search)
- Retrieve your Datadog API key from the Datadog dashboard under API Keys.

### Setup :hammer_and_wrench:

Follow these steps to set up and deploy the repository:

#### 1. Clone the repository

```
git clone https://github.com/Azure-Samples/terraform-azure-datadog-log-forwarder.git  
cd your-repo  
```

#### 2. Configure Azure Credentials

Login to Azure and set the default Subscription

```
az login  
az account set --subscription "<Your Subscription ID>"  
```

#### 3. Initialize Terraform

Initialize the Terraform project to download providers and prepare the workspace:

```
terraform init  
```

#### 4. Plan and Apply

Review the resources to be created and deploy them:

```
terraform plan -var="location=<Azure Region>" \
               -var="resource_group_name=<Resource Group Name>" \
               -var="datadog_api_key=<Your Datadog API Key>"  
terraform apply -var="location=<Azure Region>" \
                -var="resource_group_name=<Resource Group Name>" \
                -var="datadog_api_key=<Your Datadog API Key>"  
```

Replace the placeholders (`<Azure Region>`, `<Resource Group Name>`, `<Your Datadog API Key>`) with your specific values.

#### 5. Verify the Setup

Once the deployment is complete:

- Confirm that the Event Hub namespace, Datadog Azure Function, and other resources have been created in your Azure portal.
- Verify logs are being forwarded to your Datadog site as expected.
