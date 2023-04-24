#!/bin/bash

#confirmation as no tty available
az config set extension.use_dynamic_install=yes_without_prompt
#Variable to get a subscription id
export sublist="$(az account subscription list --query "[].subscriptionId") -o tsv"

#Variables to get details of SP
export SP_ID="$(az keyvault secret show --name $SECRET_PRINCIPAL_ID --vault-name $VAULT_NAME --query value  -o tsv)"
export SP_PW="$(az keyvault secret show --name $SECRET_PRINCIPAL_PW --vault-name $VAULT_NAME --query value -o tsv)"
export TENANT="$(az keyvault secret show --name $SECRET_PRINCIPAL_TENANT --vault-name $VAULT_NAME --query value -o tsv)"
export RESOURCE_LIST="$(az resource list --tag gpcms_managed=true --query "[?type=='Microsoft.Compute/virtualMachines'].id" -o tsv)"
export query="{Name:name, OPERATING_SYSTEM:storageProfile.osDisk.osType, PRIVATE_IP_ADDRESS:privateIps, GPCMS_ENV_TAG:tags.gpcms_env}"
# #Login to Azure using keyvalt secrets
az login --service-principal -u $SP_ID -p $SP_PW --tenant $TENANT
#Create a CSV file
echo "NAME,OPERATING SYSTEM,PRIVATE IP ADDRESS,GPCMS_ENV (TAG),SUBSCRIPTION ID" > vm.csv

#Get data from Azure
#For each subscription SP have access to
for i in $(az account subscription list --query "[].subscriptionId" -o tsv)
do
#Set a subscription one by one from list of subscriptions
az account set --subscription $i
#Create a VM list with tag gpcms_managed set to true
export RESOURCE_LIST="$(az resource list --tag gpcms_managed=true --query "[?type=='Microsoft.Compute/virtualMachines'].id" -o tsv)"
#Add a list of VM with require data to csv
az vm show -d --ids $RESOURCE_LIST --query $query -o tsv | sed 's/\t/,/g' | sed "s|$|\,${i}|" >> customer_vms.csv
done
