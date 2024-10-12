. .\Apache-Logs.ps1

$result = Get-ApacheLogInfo -Page "hi" -HttpCode "404" -Browser "Mozilla"
clear
Write-Host "Page: $($result.Page)"
Write-Host "HTTP Code: $($result.HttpCode)"
Write-Host "Browser: $($result.Browser)"
Write-Host "IP Addresses:"

$result.IPAddresses | Format-Table -AutoSize
