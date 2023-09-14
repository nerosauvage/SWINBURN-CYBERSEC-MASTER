#Author: Hairuo Sun
#Unit code: ICT60001
#Unit Name: Operating System Management
#Student ID: 104674810
#Purpose: A Powershell Script for Assignment 2 


# Requirement Check 
# 1. A script which mounts and dismounts the encrypted container
#  

# 2. A script which sets and removes VERAPATH and VERAPASS

# 3. A script which does (1) by checking for the existence of a sentinel and either mounts or dismounts an encrypted container.

# 4. The script displays a set-up menu and uses  this to call the find, input and remove scripts

# 5. All scripts combined in one file, and no errors are generated.





#-----------------------------------------------------------Assignment 2 Starts here-----------------------------------------------------------

# Define Menu Function
Function Menu 
{
    # Clear Host
    Clear-Host 

    # Define anyKey Function
    # Reference https://stackoverflow.com/questions/20886243/press-any-key-to-continue
    Function anyKey 
    {
        Write-Host 'Press any key to continue ...'
        $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") > $null
    }


    Function Show-Menu 
    {
        param ([string]$Title) 
        Write-Host '**********************' 
        Write-Host $Title      
        Write-Host '**********************'
    }

    # Option1 Function
    Function Option1 
    {
        Write-Host "Option 1 started" -ForegroundColor Yellow
    
        # Find vera.exe from the path | select the first file that has found
        $veracryptPath = Get-ChildItem -Path "C:\apps\VeraCrypt" | Where-Object { $_.Name -eq "veracrypt.exe" } | Select-Object -First 1
    
        if ($veracryptPath) 
        {
            # Find path
            Write-Host "Found veracrypt.exe at: $($veracryptPath.FullName)" -ForegroundColor Green
    
            # Get path
            $directoryPath = $veracryptPath.DirectoryName
    
            #method .net | path added to %VERAPATH%
            [System.Environment]::SetEnvironmentVariable('VERAPATH', $directoryPath, 'User')
    
            # Success Msg
            Write-Host "veracrypt.exe located and its path added to %VERAPATH%." -ForegroundColor Green
        } 
        else 
        {
            # Err Msg
            Write-Host "veracrypt.exe not found in the specified directory." -ForegroundColor Red
        }
    
        Write-Host "Option 1 completed" -ForegroundColor Yellow
    }

    # Option2 Function
    Function Option2 
    {
        # Prompt = Enter the password and set a secure string for it.
        $password = Read-Host -Prompt 'Enter password for VERAPASS' -AsSecureString
        # Set the env and save the password into it
        # Ref: https://learn.microsoft.com/en-us/dotnet/api/system.environment.setenvironmentvariable?view=net-7.0
        [System.Environment]::SetEnvironmentVariable('VERAPASS', $password, 'User')
        # Success message
        Write-Host "Password added to %VERAPASS%" -ForegroundColor Green
    }

    # Option3 Function
    Function Option3 
    {
        # Delete Env Var
        [System.Environment]::SetEnvironmentVariable('VERAPASS', $null, 'User')
        [System.Environment]::SetEnvironmentVariable('VERAPATH', $null, 'User')
        # Success Msg
        Write-Host "%VERAPASS% and %VERAPATH% removed" -ForegroundColor Green
    }

    Function Option4
    # define value for %VERAPASS%
    {$veraPathValue = (Get-Item Env:VERAPATH -ErrorAction SilentlyContinue).Value

    if ($veraPathValue) {
    # If value exist, then say
        Write-Host "Environment variable VERAPATH exists with value: $veraPathValue"
    } else {
    # if value does not exist, then say
        Write-Host "Environment variable VERAPATH does not exist."
    }
    }
    Function Option5
    {
     # define value for %VERAPASS% 
    $veraPassValue = (Get-Item Env:VERAPASS -ErrorAction SilentlyContinue).Value

    if ($veraPassValue) {
    # IF value exist, then say
    Write-Host "Environment variable VERAPASS exists with value: $veraPassValue"
    } else {
    # If value does not exist, then say
    Write-Host "Environment variable VERAPASS does not exist."
    }

    }

    Function Option6
    # Mount and dismount
    # A script which mounts and dismounts the encrypted container
    # Reference: https://www.veracrypt.fr/en/Command%20Line%20Usage.html
    {
        # define value = Dummy file '104674810.txt' exsit on disk Z.
        $fileExistsBeforeMount = Test-Path "Z:\104674810.txt"
    
        if ($fileExistsBeforeMount) {
            Write-Host "Drive Z is already mounted. Dummy file detected."
        } else {
            Write-Host "Dummy file not detected. Mounting drive Z..."
            # Exucte veracrypt to mount the disk 'Z' with commands.
            # /v volume file path ; /password password /l Z disk letter name 'Z'; /s Slient mode
            & "C:\apps\VeraCrypt\VeraCrypt.exe" /q /v "c:\users\nero\desktop\assign2.hc" /password 123456 /l Z /s
    
            # Delay the start by five seconds to ensure that Veracrypt will mount the disk first, so as to correctly check whether it is successfully mounted.
            Start-Sleep -Seconds 5
    
            # Check disk if mounted or not by looking for dummy file in disk Z
            $fileExistsAfterMount = Test-Path "Z:\104674810.txt"
            
            if ($fileExistsAfterMount) {
                Write-Host "Drive Z mounted successfully!"
            } else {
                Write-Host "Failed to mount Drive Z."
            }
        }
    }
    
    
    Function Option7
    # Mount and dismount
    # A script which mounts and dismounts the encrypted container
    # Reference: https://www.veracrypt.fr/en/Command%20Line%20Usage.html
    {
    # define value = Dummy file '104674810.txt' exsit on disk Z.
    $fileExists = Test-Path "Z:\104674810.txt"

    if ($fileExists) {
        # if dummy file can be find on the targeted path, then dismount.
        # /dismount Z  dismount disk 'Z' ; /s Silent mode;
        & 'C:\apps\VeraCrypt\VeraCrypt.exe' /dismount Z /s
        Write-Host "Drive Z has been dismounted."
    } else {
        Write-Host "File 104674810.txt does not exist on Z: drive. Consider mounting the drive if needed."
    }
}



    # Do-Until loop, Keep showing the menu, till user decides to quit
    Do
    {
        Clear-Host     

        # Welcome Message
        Show-Menu -Title 'ICT-60001 Assignment 2'
        Write-Host 'Hairuo Sun - 104674810' -ForegroundColor DarkGreen

        # Welcome Noitce
        Show-Menu -Title 'Notice'
        Write-Host '1. The reference, source has written in the comments, check the code if needed. tbd..'
        Write-Host '2. To use this script you may run Powershell as Administrator.'
        Write-Host '3. To *Set or Remove* the Environment Variable, you must *run Powershell in Administrator*.' -ForegroundColor Red
        Write-Host '4. To *Set or Remove* the Environment Variable, you may need to restart the powershell to see the result' -ForegroundColor Red
        Write-Host '5. If you cannot execute the option, please check the privileges by entering **Get-ExecutionPolicy**. Make sure it set as unrestricted' -ForegroundColor Red

        # Show option 1-7
        Show-Menu -Title 'Options 1-7'
        Write-Host '1. Locates veracrypt.exe and adds its location to the new search path (%VERAPATH%).'
        Write-Host '2. Prompts for input of a password and adds it to a new environment variable %VERAPASS%'
        Write-Host '3. Removes the environment variables %VERAPASS% and %VERAPATH%'
        Write-Host '4. Check %VERPATH Status ' '<Quick For Marking> <*New Session Required*>' -ForegroundColor Red
        Write-Host '5. Check %VERPASS Status ' '<Quick For Marking> <*New Session Required*>' -ForegroundColor Red
        Write-Host '6. Mount Container if dummy file cannot be detected'
        Write-Host '7. Dismount Container if dummy file can be detected'


        
        #  Prompt option 1-7
        $Menu = Read-Host -Prompt '(1-7 or Q to Quit)'
        switch ($Menu) 
        {
            1 
            {
                Option1   
                anyKey    
            }
            
            2   
            {
                Option2   
                anyKey    
            }

            3         
            {
               Option3   
               anyKey    
            }

            4
            {
                Option4
                anyKey
            }

            5
            {
                Option5
                anyKey
            }

            6{
                Option6
                anyKey

            }

            7{
                Option7
                anyKey

            }

            'q' 
            {
                exit     # close the powershell tab
            }

            default 
            {
                # Error input
                Write-Host "Invalid choice. Please select from the options." -ForegroundColor Red
                anyKey
            }
        }
    }
    until ($Menu -eq 'q')   # Enter Q to quit the loop
}   

# Menu
Menu
#-----------------------------------------------------------Assignment 2 ends here-----------------------------------------------------------