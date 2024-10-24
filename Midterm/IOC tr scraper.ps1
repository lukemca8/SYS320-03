function gatherClasses(){

$page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.5/IOC.html


# Get all the tr elements of HTML document
$trs = $page.ParsedHtml.getElementsByTagName("tr")

# Empty array to hold results
$fullTable = @()
for($i=1; $i -lt $trs.length; $i++) { # Going over every tr element

    # Get every td element of current tr element
    $tds = $trs[$i].getElementsByTagName("td")



    # Want to separate start time and end time from one time field

    
                               
} 
$fullTable += [PSCustomObject]@{"Headers"    = $tds[0].innerText
                                    "Title"      = $tds[1].innerText
                                    "Days"       = $tds[2].innerText
                                    "Time Start" = $tds[3].innerText
                                    "Time End"   = $tds[4].innerText
                                    "Instructor" = $tds[5].innerText
                                    "Location"   = $tds[6].innerText
                                    }
                                    }
                                    return $fullTable

