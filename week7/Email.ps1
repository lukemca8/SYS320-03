﻿function SendAlertEmail($Body) {

$From = "luke.mckay@mymail.champlain.edu"

$To = "luke.mckay@mymail.champlain.edu"

$Subject = "Suspicious Activity"

$Password = "hjxt quku ohkx yxla" | ConvertTo-SecureString -AsPlainText -Force

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password

Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" -port 587 -UseSsl -Credential $Credential

}