#!/bin/bash
set -e

echo "Starting staged deployment..."

# Remove any existing resource group with this name
echo "Checking if resource group exists..."
if az group show --name rg-dd-log-forwarder-jzbku >/dev/null 2>&1; then
  echo "Resource group exists, removing..."
  az group delete -n rg-dd-log-forwarder-jzbku --yes
  echo "Waiting for resource group deletion to complete..."
  while az group show --name rg-dd-log-forwarder-jzbku >/dev/null 2>&1; do
    echo "Still deleting..."
    sleep 10
  done
  echo "Resource group deleted"
else
  echo "Resource group does not exist, proceeding with deployment"
fi

# Staged deployment
echo "Initializing Terraform..."
terraform init

echo "Stage 1: Deploying resource group and storage account..."
terraform apply -target=module.prerequisites.azurerm_resource_group.resource_group -parallelism=1 -auto-approve
sleep 30  # Allow Azure to propagate the resource group creation

echo "Stage 2: Creating storage account..."
terraform apply -target=module.prerequisites.azurerm_storage_account.storage_account -parallelism=1 -auto-approve
sleep 30  # Allow Azure to propagate the storage account

echo "Stage 3: Creating virtual network resources..."
terraform apply -target=module.prerequisites -parallelism=1 -auto-approve
sleep 30  # Allow Azure to propagate networking changes

echo "Stage 4: Creating Event Hub resources..."
terraform apply -target=module.eventhub -parallelism=1 -auto-approve
sleep 30  # Allow Azure to propagate Event Hub changes

echo "Stage 5: Creating Function App resources..."
terraform apply -target=module.function -parallelism=1 -auto-approve
sleep 30  # Allow Azure to propagate Function App changes

echo "Stage 6: Completing deployment..."
terraform apply -parallelism=1 -auto-approve

echo "Deployment complete!" 