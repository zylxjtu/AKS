#az vm image list --all --location "westus" --publisher "MicrosoftWindowsserver" --offer "WindowsServer" --sku "2022-datacenter-core-smalldisk"
#to get the urn

#urn="MicrosoftWindowsServer:WindowsServer:2022-datacenter-core-smalldisk:20348.2402.240405"

urn=""
destinationToken=""  
  
diskName="xxxx"
diskRG="xxxx"

az disk create -g $diskRG -n $diskName --image-reference $urn

diskAccessSAS=$(az disk grant-access --duration-in-seconds 36000 --access-level Read --name $diskName --resource-group $diskRG |jq -r '.access')

echo $diskAccessSAS

azcopy copy '$diskAccessSAS' '$destinationToken'
