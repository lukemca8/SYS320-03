$chrome = Get-Process -Name "chrome" -ErrorAction SilentlyContinue



if ($chrome) {

    # Stop Chrome if it's already running

        Stop-Process -Name "chrome" -Force

        } else {

            # Start Chrome and direct to Champlain.edu

                Start-Process "chrome.exe" "https://www.champlain.edu"

                }