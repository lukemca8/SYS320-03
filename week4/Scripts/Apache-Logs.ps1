function Get-ApacheLogInfo {
    param([string]$Page,[string]$HttpCode,[string]$Browser)

    $logs = Get-Content C:\xampp\apache\logs\access.log | Select-String "$Page.*$HttpCode.*$Browser"
    
    $regex = [regex]"\b(?:\d{1,3}\.){3}\d{1,3}\b"
    $ips = $regex.Matches($logs) | ForEach-Object { $_.Value }
    $ipCounts = $ips | Group-Object | Select-Object Count, Name

    $result = [PSCustomObject]@{
        Page = $Page
        HttpCode = $HttpCode
        Browser = $Browser
        IPAddresses = $ipCounts
    }
    return $result
}