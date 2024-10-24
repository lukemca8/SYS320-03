function readConfiguration {

    $config = Get-Content -Path "C:\Users\champuser\SYS320-03\week7\configuration.txt" | ConvertFrom-Json

    return [PSCustomObject]@{

        Days = $config.Days

        ExecutionTime = $config.ExecutionTime

    }

}



function changeConfiguration {

    $days = Read-Host "Enter the number of days"

    while ($days -notmatch '^\d+$') {

        $days = Read-Host "Invalid input. Enter the number of days"

    }



    $executionTime = Read-Host "Enter the execution time (format: H:mm AM/PM)"

    while ($executionTime -notmatch '^(1[0-2]|0?[1-9]):([0-5][0-9]) (AM|PM)$') {

        $executionTime = Read-Host "Invalid input. Enter the execution time (format: H:mm AM/PM)"

    }



    @{

        Days = [int]$days

        ExecutionTime = $executionTime

    } | ConvertTo-Json | Set-Content -Path "C:\Users\champuser\SYS320-03\week7\configuration.txt"

}



function configurationMenu {

    while ($true) {

        Write-Host "1. Show configuration"

        Write-Host "2. Change configuration"

        Write-Host "3. Exit"

        $choice = Read-Host "Enter your choice"



        switch ($choice) {

            '1' {

                $config = readConfiguration

                Write-Host "Days: $($config.Days)"

                Write-Host "Execution Time: $($config.ExecutionTime)"

            }

            '2' {

                changeConfiguration

                Write-Host "Configuration updated."

            }

            '3' {

                Write-Host "Exiting..."

                return

            }

            default {

                Write-Host "Invalid choice. Please try again."

            }

        }

    }

}