#!/bin/bash
set -e

echo "Redeploying Event Hub Trigger Function..."

# Get the current directory where the script is being run
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Force file hash change to trigger redeployment
TIMESTAMP=$(date +%s)
echo "// Trigger redeployment $TIMESTAMP" >> $SCRIPT_DIR/modules/function-app/functions/dd-log-forwarder/index.js

# Run Terraform apply
terraform apply -auto-approve -target="module.function.null_resource.function_app_publish"

echo "Event Hub Trigger Function redeployed successfully!" 