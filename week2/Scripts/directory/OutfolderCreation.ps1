# Create folder if it does not exist

$folderPath = "$PSScriptRoot\outfolder"



if (-Not (Test-Path $folderPath)) {

    New-Item -ItemType Directory -Path $folderPath

    } else {

        Write-Host "Folder Already Exists"

        }