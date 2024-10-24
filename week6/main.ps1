﻿. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt  = "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - Exit`n"
$Prompt += "10 - List at Risk Users"



$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 9){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }



  # Create a user
elseif($choice -eq 2){
    $name = Read-Host -Prompt "Please enter the username for the new user"

    $chkUser = checkUser $name
    if($chkUser -ne $true){

        $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"

        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
        $plainpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

        $chkPassed = checkPassword $plainpassword

        if($chkPassed -eq $true){
            New-LocalUser -Name $name -Password $password
            Write-Host "User: $name is created." | Out-String
        }
        else{ 
            Write-Host "Password should be more than 5 characters and include at least 1 special character, 1 number, and 1 letter." | Out-String
        }
    }
    else{ 
        Write-Host "User name already exists." | Out-String 
    }
}
        # TODO: Create a function called checkUser in Users that: 
        #              - Checks if user a exists. 
        #              - If user exists, returns true, else returns false
        # TODO: Check the given username with your new function.
        #              - If false is returned, continue with the rest of the function
        #              - If true is returned, do not continue and inform the user
        #
        # TODO: Create a function called checkPassword in String-Helper that:
        #              - Checks if the given string is at least 6 characters
        #              - Checks if the given string contains at least 1 special character, 1 number, and 1 letter
        #              - If the given string does not satisfy conditions, returns false
        #              - If the given string satisfy the conditions, returns true
        # TODO: Check the given password with your new function. 
        #              - If false is returned, do not continue and inform the user
        #              - If true is returned, continue with the rest of the function

        createAUser $name $password

        Write-Host "User: $name is created." | Out-String
    }


# Remove a user
elseif($choice -eq 4){

    $name = Read-Host -Prompt "Please enter the username for the user to be removed"

    
    $chkUser = checkUser $name

    if($chkUser -eq $true){

        Remove-LocalUser -Name $name

        Write-Host "User: $name Removed." | Out-String

    }

    else{ 

        Write-Host "User does not exist." | Out-String

    }


    # Enable a user
    elseif($choice -eq 5){


        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"

        # TODO: Check the given username with the checkUser function.

        enableAUser $name

        Write-Host "User: $name Enabled." | Out-String
    }


    # Disable a user
    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        # TODO: Check the given username with the checkUser function.

        disableAUser $name

        Write-Host "User: $name Disabled." | Out-String
    }


    elseif($choice -eq 7){

        $name = Read-Host -Prompt "Please enter the username for the user logs"

        # TODO: Check the given username with the checkUser function.

        $userLogins = getLogInAndOffs 90
        # TODO: Change the above line in a way that, the days 90 should be taken from the user

        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }


    elseif($choice -eq 10){

        $Days = Read-Host -Prompt "Please enter the number of days"

        # TODO: Check the given username with the checkUser function.

       Write-Output atRiskUsers (10)
        # TODO: Change the above line in a way that, the days 90 should be taken from the user

        Write-Host ($Users | Format-Table | Out-String)
    }
     
     elseif($choice -eq 8){

        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"

        # TODO: Check the given username with the checkUser function.

        $userLogins = getFailedLogins 90
        # TODO: Change the above line in a way that, the days 90 should be taken from the user

        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }

    # TODO: Create another choice "List at Risk Users" that
    #              - Lists all the users with more than 10 failed logins in the last <User Given> days.  
    #                (You might need to create some failed logins to test)
    #              - Do not forget to update prompt and option numbers
    
    # TODO: If user enters anything other than listed choices, e.g. a number that is not in the menu   
    #       or a character that should not be accepted. Give a proper message to the user and prompt again.
    

}




