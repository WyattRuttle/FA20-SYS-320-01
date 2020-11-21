$myDir = "C:\Users\Admin\Documents\SYS-330\Files\Test"
function saveFile{
    $saveIt = Read-Host -Prompt "Do you want to save the file? Y/N"
        if($saveIt -eq 'y'){
            $nameFile = Read-Host -Prompt "What is the filename?"
            $myDir = Read-Host "Where do you want to save the file? ex: C:\Users\Admin\Documents\SYS-330\Files"
            $command | Out-File -FilePath "$myDir\$nameFile.csv"
            }
}
function mainMenu {
    $mainMenu = 'open'
    while($mainMenu -ne 'E'){
        Clear-Host
        Write-Host -ForegroundColor Yellow "===== Main Menu for Incident Response ====="
        Write-Host " "
        Write-Host "1: Open Toolkit"
        Write-Host " "
        Write-Host "2: Create Checksum of results"
        Write-Host " "
        Write-Host "[E]xit"
        Write-Host " "
        $mainMenu = Read-Host "Enter choice"
        if($mainMenu -eq 1){
            toolMenu
        }
        elseif($mainMenu -eq 2){
            checksumSend
        }
        elseif($mainMenu -eq 'e'){
            Write-Host "Goodbye! :)"
        }
        else{
            Write-Host "Value entered is invalid. Try again."
            pause
        }
    }
}
function checksumSend {
    $checksumSend = 'open'
    while($checksumSend -ne 'E'){
        Clear-Host
        Write-Host -ForegroundColor Yellow "===== Checksum Menu ====="
        Write-Host " "
        Write-Host "1: Create Checksum of results"
        Write-Host " "
        Write-Host "2: Zip File"
        Write-Host " "
        Write-Host "3: Email Zipped file"
        Write-Host " "
        Write-Host "[E]xit"
        Write-Host " "
        $checksumSend = Read-Host "Enter choice"
        if($checksumSend -eq 1){
            Get-ChildItem -Path "$myDir" | Get-FileHash | Out-File -FilePath "$myDir\checksum.txt"
        }
        elseif($checksumSend -eq 2){
            Compress-Archive -Path "$myDir"
        }
        elseif($checksumSend -eq 3){
            Send-MailMessage -From "Wyatt.ruttle@mymail.champlain.edu" -to "deployer@csi-web" -Subject "Week 12" -Body "Checksum and Zip file attached" -Attachments "C:\Users\Admin\Documents\SYS-330\Files\Test.zip" -SmtpServer 192.168.6.71
        }
        elseif($checksumSend -eq 'e'){
            mainMenu
        }
        else{
            Write-Host "Value entered is invalid. Try again."
            pause
        }
    }
}

function toolMenu {
    $toolMenu = 'open'
    while($toolMenu -ne 'E'){
        Clear-Host
        Write-Host -ForegroundColor Yellow "===== Incident Response Toolkit ====="
        Write-Host " "
        Write-Host "1: Running Processes"
        Write-Host " "
        Write-Host "2: Registered services"
        Write-Host " "
        Write-Host "3: All TCP network sockets"
        Write-Host " "
        Write-Host "4: User account information"
        Write-Host " "
        Write-Host "5: NetworkAdapterConfiguration information"
        Write-Host " "
        Write-Host "6: Registry Entries"
        Write-Host " "
        Write-Host "7: System startup"
        Write-Host " "
        Write-Host "8: Scheduled Tasks"
        Write-Host " "
        Write-Host "9: Show Firewall rules"
        Write-Host " "
        Write-Host "[E]xit"
        Write-Host " "
        $toolMenu = Read-Host "Enter choice"
        # Running Processes and the path for each process.
        if($toolMenu -eq 1){
            $command = Get-Process
            $command
            saveFile
        }
        #All registered services and the path to the executable controlling the service (you'll need to use WMI)
        elseif($toolMenu -eq 2){
            $command = Get-Service
            $command
            saveFile
        }
        #All TCP network sockets
        elseif($toolMenu -eq 3){
            $command = Get-NetTCPConnection
            $command
            saveFile
        }
        #All user account information (you'll need to use WMI)
        elseif($toolMenu -eq 4){
            $command = Get-WmiObject -Class Win32_UserAccount -Filter "Name='$env:username' and Domain='$env:userdomain'" | Select-Object * 
            $command
            saveFile
        }
        #All NetworkAdapterConfiguration information
        elseif($toolMenu -eq 5){
            $command = Get-WmiObject Win32_NetworkAdapterConfiguration | Get-Member -MemberType Property | Where-Object {$_.name -NotMatch "__"}
            $command
            saveFile
        }
        #Shows windows registry entries
        #Registry is an internal database storing settings for Windows and applications
        #A tactic that has been growing increasingly common is the use of registry -> 
        # keys to store and hide next step code for malware after it has been dropped on a system
        elseif($toolMenu -eq 6){
            $command = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion
            $command
            saveFile
        }
        #Shows applications in startup
        #Many viruses automatically run when Windows is booted up
        #One way to find a virus is to check startup for suspicious entries
        elseif($toolMenu -eq 7){
            $command = wmic startup get caption,command
            $command
            saveFile
        }
        #Shows scheduled tasks
        #The Task Scheduler is used by malware to run at regular intervals without triggering the UAC prompts
        elseif($toolMenu -eq 8){
            $command = Get-ScheduledTask
            $command
            saveFile
        }
        #Check firewall rules
        #Firewalls traffic access between computer the internet
        #Checking the firewall rules is an important step to see if any have been disabled by the malware
        elseif($toolMenu -eq 9){
            $command = Get-NetFirewallRule
            $command
            saveFile
        }
        #Option to quit
        elseif($toolMenu -eq 'e'){
            mainMenu
        }
        #Invalid Value
        else{
            Write-Host "Value entered is invalid. Try again."
            pause
        }
    }
}
#Call the menu function so it displays
mainMenu