. (Join-Path $PSScriptRoot String-Helper.ps1)


<# ******************************
     Function Explaination
****************************** #>
function getLogInAndOffs($timeBack){

$loginouts = Get-EventLog system -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays("-"+"$timeBack")

$loginoutsTable = @()
for($i=0; $i -lt $loginouts.Count; $i++){

$type = ""
if($loginouts[$i].InstanceID -eq 7001) {$type="Logon"}
if($loginouts[$i].InstanceID -eq 7002) {$type="Logoff"}


# Check if user exists first
$user = (New-Object System.Security.Principal.SecurityIdentifier `
         $loginouts[$i].ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])

$loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated; `
                                       "Id" = $loginouts[$i].InstanceId; `
                                    "Event" = $type; `
                                     "User" = $user;
                                     }
} # End of for

return $loginoutsTable
} # End of function getLogInAndOffs




<# ******************************
     Function Explaination
****************************** #>
function getFailedLogins($timeBack){
  
  $failedlogins = Get-EventLog security -After (Get-Date).AddDays("-"+"$timeBack") | Where { $_.InstanceID -eq "4625" }

  $failedloginsTable = @()
  for($i=0; $i -lt $failedlogins.Count; $i++){

    $account=""
    $domain="" 

    $usrlines = getMatchingLines $failedlogins[$i].Message "*Account Name*"
    $usr = $usrlines[1].Split(":")[1].trim()

    $dmnlines = getMatchingLines $failedlogins[$i].Message "*Account Domain*"
    $dmn = $dmnlines[1].Split(":")[1].trim()

    $user = $dmn+"\"+$usr;

    $failedloginsTable += [pscustomobject]@{"Time" = $failedlogins[$i].TimeGenerated; `
                                       "Id" = $failedlogins[$i].InstanceId; `
                                    "Event" = "Failed"; `
                                     "User" = $user;
                                     }

    }

    return $failedloginsTable
} # End of function getFailedLogins


#At Risk Users (lists users with more than 10 failed logins in the last given amount of days.
function atRiskUsers($Days) {

    $startTime = (Get-Date).AddDays(-$Days)



    $failedLogins = Get-EventLog -LogName Security -EntryType FailureAudit -After $startTime |

                    Where-Object { $_.EventID -eq 4625 } |

                    Select-Object -Property @{Name='User';Expression={$_.ReplacementStrings[5]}}, TimeGenerated



    $atRiskUsers = $failedLogins |

                   Group-Object -Property User |

                   Where-Object { $_.Count -gt 10 } |

                   Select-Object -Property Name, Count



    $atRiskUsersFormatted = $atRiskUsers | ForEach-Object {

        "User: $($_.Name), Failed Logins: $($_.Count)"

    }



    if ($atRiskUsersFormatted) {

        return "At-Risk Users (more than 10 failed logins in the last $Days days):`n$($atRiskUsersFormatted -join "`n")"

    } else {

        return "No at-risk users found in the last $Days days."

    }

}