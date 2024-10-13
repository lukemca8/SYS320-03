function gatherClasses(){

$page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.13/Courses.html


# Get all the tr elements of HTML document
$trs = $page.ParsedHtml.getElementsByTagName("tr")

# Empty array to hold results
$fullTable = @()
for($i=1; $i -lt $trs.length; $i++) { # Going over every tr element

    # Get every td element of current tr element
    $tds = $trs[$i].getElementsByTagName("td")

    # Want to separate start time and end time from one time field
    $times = $tds[5].innerText -split ' - '


    $fullTable += [PSCustomObject]@{"Class Code" = $tds[0].innerText
                                    "Title"      = $tds[1].innerText
                                    "Days"       = $tds[4].innerText
                                    "Time Start" = $times[0]
                                    "Time End"   = $times[1]
                                    "Instructor" = $tds[6].innerText
                                    "Location"   = $tds[9].innerText
                               }
} # end of for loop
return $fullTable
}



function DaysTranslator($fullTable) {

    Write-Host "DaysTranslator started. Number of classes to process: $($fullTable.Count)"

    

    for ($i = 0; $i -lt $fullTable.Count; $i++) {

        $Days = @()

        $originalDays = $fullTable[$i].Days

        Write-Host "Processing class $($i+1): Original Days = '$originalDays'"

        

        if ($originalDays -match 'M') { $Days += "Monday" }

        if ($originalDays -match 'T' -and $originalDays -notmatch 'TH') { $Days += "Tuesday" }

        if ($originalDays -match 'W') { $Days += "Wednesday" }

        if ($originalDays -match 'TH') { $Days += "Thursday" }

        if ($originalDays -match 'F') { $Days += "Friday" }

        

        $fullTable[$i].Days = $Days -join ", "

        Write-Host "Processed class $($i+1): New Days = '$($fullTable[$i].Days)'"

    }

    

    Write-Host "DaysTranslator completed"

    return $fullTable

}



# Main script

Write-Host "Starting script execution"



$fullTable = GatherClasses

Write-Host "Classes gathered. Showing first 3 classes:"

$fullTable | Select-Object -First 3 | Format-Table "Class Code", Title, Days, "Time Start", "Time End", Instructor, Location



Write-Host "Now calling DaysTranslator function"

$fullTable = DaysTranslator $fullTable



Write-Host "Translation completed. Showing first 3 translated classes:"

$fullTable | Select-Object -First 3 | Format-Table "Class Code", Title, Days, "Time Start", "Time End", Instructor, Location



Write-Host "Script execution completed"

$fullTable | Format-Table

Write-Host "Classes taught by Furkan Paligu:"

$fullTable | Where-Object { $_.Instructor -eq "Furkan Paligu" } | Format-Table "Class Code", Instructor, Location, Days, "Time Start", "Time End"

Write-Host "Classes in JOYC 310 on Mondays, sorted by start time:"

$fullTable | 

    Where-Object { $_.Location -eq "JOYC 310" -and $_.Days -like "*Monday*" } | 

    Sort-Object "Time Start" | 

    Select-Object "Class Code", "Time Start", "Time End" |

    Format-Table


$ITSInstructors = $fullTable | 

    Where-Object { 

        $_."Class Code" -like "SYS*" -or 

        $_."Class Code" -like "NET*" -or 

        $_."Class Code" -like "SEC*" -or 

        $_."Class Code" -like "FOR*" -or 

        $_."Class Code" -like "CSI*" -or 

        $_."Class Code" -like "DAT*"

    } | 

    Select-Object -ExpandProperty Instructor | 

    Sort-Object | 

    Get-Unique



$ITSInstructors


$fullTable | 

    Group-Object -Property Instructor | 

    Where-Object { $_.Name -in $ITSInstructors } |

    Select-Object @{Name='Instructor'; Expression={$_.Name}}, Count | 

    Sort-Object Count -Descending