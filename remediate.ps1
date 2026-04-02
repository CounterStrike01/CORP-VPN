Set-ExecutionPolicy Bypass -Scope Process -Force
$ErrorActionPreference = "Stop"

function Test-VpnNameAvailable {
    param ([string]$nameToTest)
    $vpnTest = Get-VpnConnection -AllUserConnection -Name $nameToTest -ErrorAction SilentlyContinue
    return ($vpnTest -eq $null)
}

function Configure-Vpn {
    if (Test-VpnNameAvailable -nameToTest "CORP-VPN") {
        Add-VpnConnection -Name "CORP-VPN" -ServerAddress "216.251.139.254" -TunnelType L2tp -L2tpPsk "suJNPLnjTQXXCp3KtgOq1cKRLFZ0NblJ" -AuthenticationMethod MSChapv2 -AllUserConnection -RememberCredential -Force -Passthru
    } else {
        Remove-VpnConnection -AllUserConnection -Name "CORP-VPN" -Force
        Add-VpnConnection -Name "CORP-VPN" -ServerAddress "216.251.139.254" -TunnelType L2tp -L2tpPsk "suJNPLnjTQXXCp3KtgOq1cKRLFZ0NblJ" -AuthenticationMethod MSChapv2 -AllUserConnection -RememberCredential -Force -Passthru
    }

    Start-Sleep -Seconds 3

    $interface = Get-NetAdapter | Where-Object { $_.InterfaceDescription -like "*WAN Miniport (L2TP)*" -and $_.Status -eq "Up" }
    if ($interface) {
        $interfaceAlias = $interface.Name
        Set-DnsClientServerAddress -InterfaceAlias $interfaceAlias -ServerAddresses ['172.19.115.190', '172.19.115.187', '172.19.115.188'] -ErrorAction SilentlyContinue
        Disable-NetAdapterBinding -Name $interfaceAlias -ComponentID ms_tcpip6 -Confirm:$false -ErrorAction SilentlyContinue
    } else {
        Write-Host "VPN interface not found or not active. DNS and IPv6 settings may not be applied."
    }
}

Configure-Vpn

# Add static routes
Write-Host "Adding static routes..."
Start-Process -FilePath "route.exe" -ArgumentList "-p ADD 172.19.30.0 MASK 255.255.255.0 192.168.8.1" -Verb RunAs -WindowStyle Hidden
Start-Process -FilePath "route.exe" -ArgumentList "-p ADD 172.19.115.0 MASK 255.255.255.0 192.168.8.1" -Verb RunAs -WindowStyle Hidden
