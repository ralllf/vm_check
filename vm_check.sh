#!/bin/bash

#confirmation as no tty available
az config set extension.use_dynamic_install=yes_without_prompt
#Variable to get a subscription id
export sublist="$(az account subscription list --query "[].subscriptionId" -o tsv)"

#Variables to get details of SP
export SP_ID="$(az keyvault secret show --name $SECRET_PRINCIPAL_ID --vault-name $VAULT_NAME --query value  -o tsv)"
export SP_PW="$(az keyvault secret show --name $SECRET_PRINCIPAL_PW --vault-name $VAULT_NAME --query value -o tsv)"
export TENANT="$(az keyvault secret show --name $SECRET_PRINCIPAL_TENANT --vault-name $VAULT_NAME --query value -o tsv)"
export RESOURCE_LIST=`$(az resource list --tag gpcms_managed=true --query "[?type=='Microsoft.Compute/virtualMachines'].id" -o tsv)`
# #Login to Azure using keyvalt secrets
az login --service-principal -u $SP_ID -p $SP_PW --tenant $TENANT

#Get data from Azure
az vm show -d --ids $RESOURCE_LIST --query "[].{Name:name, OPERATING_SYSTEM:storageProfile.imageReference.offer, PRIVATE_IP_ADDRESS:privateIps, GPCMS_ENV_TAG:tags.gpcms_env}" -o tsv
