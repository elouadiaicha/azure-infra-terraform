#!/bin/bash

set -euo pipefail

# ==========================================
# Terraform Backend Initialization
# ==========================================

source "$(dirname "$0")/config.sh"

cd "$(dirname "$0")/../terraform"

echo ""
echo "========================================="
echo "Initializing Terraform Backend with OIDC"
echo "========================================="

terraform init \
  -backend-config="resource_group_name=$RG_BACKEND" \
  -backend-config="storage_account_name=$SA_BACKEND" \
  -backend-config="container_name=$CONTAINER_NAME" \
  -backend-config="key=$BACKEND_KEY" \
  -backend-config="use_oidc=true" \
  -backend-config="use_azuread_auth=true"

echo ""
echo "Terraform initialized successfully."