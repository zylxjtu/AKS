#!/bin/bash

RESOURCE_GROUP_NAME="wcct-agentbaker-test-20348.2346.240312-azure" \
CLUSTER_NAME="wcct-agentbaker-test-aks" \

az aks update \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $CLUSTER_NAME \
    --network-policy azure
