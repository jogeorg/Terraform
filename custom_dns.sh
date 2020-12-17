#!/bin/sh


#######################################################
# Read input
#######################################################
eval "$(jq -r '@sh "metadata_host=\(.metadata_host) environment=\(.environment) client_id=\(.client_id) client_secret=\(.client_secret) tenant_id=\(.tenant_id) subscription_id=\(.subscription_id) resource_group_name=\(.resource_group_name) vnet_name=\(.vnet_name) dns_servers=\(.dns_servers)"')"


#######################################################
# Authenticate to Azure
#######################################################
setAzureEnvironment=$(az cloud set --name $environment)
authenticateToAzure=$(az login --service-principal -u $client_id --password=$client_secret --tenant $tenant_id --subscription $subscription_id)


#######################################################
# Switch to Custom DNS
#######################################################
customDns=$(az network vnet update -g $resource_group_name -n $vnet_name --dns-servers $dns_servers 168.63.129.16 --subscription $subscription_id)

sleep 60

jq -n --arg customDns "$customDns" '{"customDns":$customDns}'
