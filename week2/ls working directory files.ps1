cd $PSScriptRoot

$files = Get-ChildItem -Path $PSScriptRoot -Filter "*.ps1"

$folderPath = "$PSScriptRoot/outfolder/"

$filePath = "$folderPath" + "out.csv"



# List all the files that have the extension ".ps1" and save the results to out.csv file

$files | Where-Object { $_.Extension -eq ".ps1" } | 

Export-Csv -Path $filePath -NoTypeInformation