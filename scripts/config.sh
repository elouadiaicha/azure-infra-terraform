#!/bin/bash

set -euo pipefail

OWNER="${AZURE_OWNER:-aicha-elouadi}"

RG_BACKEND="${TF_BACKEND_RG:-aelouadiRG}"
SA_BACKEND="${TF_BACKEND_SA:-ststateaichaelouadi}"

CONTAINER_NAME="tfstate"
BACKEND_KEY="${OWNER}.terraform.tfstate"