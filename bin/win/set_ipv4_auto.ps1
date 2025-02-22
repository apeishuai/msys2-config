$adapter = Get-NetAdapter | Where-Object {$_.Name -eq "WLAN"} | Select-Object -First 1

if ($adapter) {
	Set-NetIPInterface -InterfaceIndex $adapter.ifIndex -Dhcp Enabled
    }
    else {
        Write-Warning "IPv4 address is not configured on adapter '$adapterName'."
    }
