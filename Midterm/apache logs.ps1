function Get-ApacheLogData{
$logsfile = Get-Content C:\Users\champuser\SYS320-03\Midterm\access.log

$logData = $logsfile | ForEach-Object {
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
}

$logData | Format-Table -Autosize