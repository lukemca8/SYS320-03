. (Join-Path $PSScriptRoot UserEventLogAnalyzerFunctions.ps1)

clear

# WinLog Events
$result = Get-WinLogonEvents -Days 30
$result | Format-Table -AutoSize

# Start and Shutdown Events
$result = Get-ComputerStartShutdownEvents -Days 30
$result | Format-Table -AutoSize