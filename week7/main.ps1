. "C:\Users\champuser\SYS320-03\week7\Email.ps1"

. "C:\Users\champuser\SYS320-03\week7\Scheduler.ps1"

. "C:\Users\champuser\SYS320-03\week7\Configuration.ps1"

. "C:\Users\champuser\SYS320-03\week6\Event-Logs.ps1"


$configuration = readConfiguration

$Failed = atRiskUsers $configuration.Days

SendAlertEmail ($Failed | Format-Table | Out-String)

ChooseTimeToRun($configuration.ExecutionTime)

