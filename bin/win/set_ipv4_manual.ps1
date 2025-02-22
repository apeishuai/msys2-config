$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1

if ($adapter) {
    Set-NetIPInterface -InterfaceIndex $adapter.ifIndex -Dhcp Disabled
    New-NetIPAddress -InterfaceIndex $adapter.ifIndex -IPAddress "192.168.1.22" -PrefixLength 24
    Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses "8.8.8.8"
    Write-Output "DHCP configuration is disabled on adapter '$adapterName'."
}
else {
    Write-Warning "Adapter '$adapterName' not found."
}
