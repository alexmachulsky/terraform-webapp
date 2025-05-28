#!/bin/bash

ENV=$1

if [[ "$ENV" != "dev" && "$ENV" != "prod" ]]; then
  echo "Usage: ./destroy.sh [dev|prod]"
  exit 1
fi

echo "🔄 Initializing backend for $ENV..."
terraform init -reconfigure -backend-config="${ENV}.tfbackend"

echo "🧠 Switching to workspace: $ENV"
if terraform workspace list | grep -q "$ENV"; then
  terraform workspace select "$ENV"
else
  echo "⚠️  Workspace '$ENV' does not exist locally. Creating it..."
  terraform workspace new "$ENV"
fi

echo "🔥 Destroying Terraform resources for $ENV..."
terraform destroy -var-file="${ENV}.tfvars"
