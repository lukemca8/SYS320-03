# Without changing directory (don't go in outfolder), find every .csv file recursively and change their extensions to .log

$files = Get-ChildItem -Path $PSScriptRoot -Recurse -File



$files | Where-Object { $_.Extension -eq '.csv' } | 

ForEach-Object { 

    Rename-Item -Path $_.FullName -NewName ($_.BaseName + '.log') 

    }



    # Recursively display all the files (not directories)

    Get-ChildItem -Path $PSScriptRoot -Recurse -File