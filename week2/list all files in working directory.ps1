cd $PSScriptRoot


$files = Get-ChildItem -Path $PSScriptRoot -Filter "*.ps1"

for ($j = 0; $j -lt $files.Count; $j++) {
    if ($files[$j].Name -like "*.ps1") {
        Write-Host $files[$j].Name
    }
}