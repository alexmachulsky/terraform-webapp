#!/bin/bash

ENV=$1

if [[ "$ENV" != "dev" && "$ENV" != "prod" ]]; then
  echo "Usage: ./run.sh [dev|prod]"
  exit 1
fi

echo "🔄 Initializing backend for $ENV..."
terraform init -reconfigure -backend-config="${ENV}.tfbackend"

# check if workspace exists
echo "🧠 Checking for existing workspace: $ENV"
if terraform workspace list | grep -q "$ENV"; then
  terraform workspace select "$ENV"
else
  terraform workspace new "$ENV"
fi

echo "🧪 Running plan for $ENV..."
terraform plan -var-file="${ENV}.tfvars"

echo "🚀 Applying Terraform for $ENV..."
terraform apply -var-file="${ENV}.tfvars"
