#!/bin/bash
#Variable to get a subscription id
export sublist="$(az account subscription list --query "[].subscriptionId" -o tsv)"

#Variables to get details of SP
export SP_ID="$(az keyvault secret show --name ${{ secrets.secret_principal_id }} --vault-name ${{ secrets.vault_name }} --query value  -o tsv)"
export SP_PW="$(az keyvault secret show --name ${{ secrets.secret_principal_pw }} --vault-name ${{ secrets.vault_name }} --query value -o tsv)"
export TENANT="$(az keyvault secret show --name ${{ secrets.secret_principal_tetant }} --vault-name ${{ secrets.vault_name }} --query value -o tsv)"

# #Login to Azure using keyvalt secrets
az login --service-principal -u $SP_ID -p $SP_PW --tenant $TENANT

#Get data from Azure
az vm show -d --ids $(az resource list --tag gpcms_managed=true --query "[?type=='Microsoft.Compute/virtualMachines'].id" -o tsv) --query "[].{Name:name, OPERATING_SYSTEM:storageProfile.imageReference.offer, PRIVATE_IP_ADDRESS:privateIps, GPCMS_ENV_TAG:tags.gpcms_env}" -o tsv
