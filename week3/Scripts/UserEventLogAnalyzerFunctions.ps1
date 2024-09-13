Function Get-ComputerStartShutdownEvents($Days){
    $events = Get-EventLog -LogName System -After (Get-Date).AddDays(-$Days) | Where-Object {$_.EventID -in (6005, 6006)}

    $eventsTable = @()

    foreach ($evt in $events) {
        $eventType = switch ($evt.EventID) {
            6005 { "Start" }
            6006 { "Shutdown" }
        }

        $eventsTable += [pscustomobject]@{
            "Time" = $evt.TimeGenerated;
            "Id" = $evt.EventID;
            "Event" = $eventType;
            "User" = "System";
        }
    }

return $eventsTable

}

# Call the function and print the results
$result = Get-ComputerStartShutdownEvents -Days 30
$result

function Get-WinLogonEvents($Days){

    $loginouts = Get-EventLog -Logname System -source Microsoft-Windows-WinLogon -After (Get-Date).AddDays(-$Days)
    $loginoutsTable = @()

    for($i=0; $i -ne $loginouts.Count; $i++){
        $event = ""
        if($loginouts[$i].InstanceId -eq 7001) {$event="Logon"}
        if($loginouts[$i].InstanceId -eq 7002) {$event="Logoff"}

        $sid = $loginouts[$i].ReplacementStrings[1]

        try {
            $user = (New-Object System.Security.Principal.SecurityIdentifier($sid)).Translate([System.Security.Principal.NTAccount]).Value
        } catch {
            $user = $sid # Fallback to SID if translation fails
        }

        $loginoutsTable += [pscustomobject]@{
            "Time" = $loginouts[$i].TimeGenerated;
            "Id" = $loginouts[$i].InstanceId;
            "Event" = $event;
            "User" = $user;
        }
    }

    return $loginoutsTable
}

# Call the function and print the results
$result = Get-WinLogonEvents -Days 30
$result