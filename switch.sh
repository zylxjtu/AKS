#!/bin/bash

export resourceGroup="${1:-wcct-agentbaker-test-27606.1000.240423}"

az aks get-credentials \
--resource-group $resourceGroup \
--name wcct-agentbaker-test-aks \
--file ${HOME}/.kube/config \
--overwrite-existing
