function Get-ApacheLogDataWithIndicators{
    param (
          [Parameter(Mandatory=$true)]
          [string]$LogFilePath,
          [Parameter(Mandatory=$true)]
          [string[]]$Indicators
          )

$logData = Get-Content -Path $LogFilePath | ForEach-Object {
    $fields = $_.Split(" ")
    [PSCustomObject]@{
        IP = $fields[0]
        Time = $fields[3].Trim("[")
        Method = $fields[5].Trim('"')
        Page = $fields[6].Trim('"')
        Protocol = $fields[7].Trim('"')
        "Response Code" = $fields[8]
        Referrer = $fields[9].Trim('"')
  }
}

$filteredLogData = $logData.Where({$_.Page -contains $Indicators })


$filteredLogData

}

$Indicators = @("bash", "sh", "backdoor")
$filteredLogs = Get-ApacheLogDataWithIndicators -LogFilePath "C:\Users\champuser\SYS320-03\Midterm\access.log" -Indicators $Indicators
$filteredLogs | Format-Table -Autosize