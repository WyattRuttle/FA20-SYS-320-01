# Storyline: lists all registered services (where stopped or running)
$myDir = "C:\Users\Admin\Documents\SYS-330\Files"
function mainMenu {
    $mainMenu = 'open'
    while($mainMenu -ne 'E'){
        Clear-Host
        Write-Host -ForegroundColor Yellow "===== lists registered services ====="
        Write-Host " "
        Write-Host "1: list ALL registered services"
        Write-Host " "
        Write-Host "2: list STOPPED registered services"
        Write-Host " "
        Write-Host "3: list RUNNING registered services"
        Write-Host " "
        Write-Host "[E]xit"
        Write-Host " "
        $mainMenu = Read-Host "Enter choice"
        #List all services
        if($mainMenu -eq 1){
            Get-Service
            pause
        }
        #List stopped services
        elseif($mainMenu -eq 2){
            Get-Service | Where-Object {$_.Status -eq "Stopped"}
            $makeFile = Read-Host "Enter 1 to save file, anything else to proceed"
            if($makeFile -eq 1){
                Get-Service | Where-Object {$_.Status -eq "Stopped"} | Export-Csv -Path "$myDir\wyatt.ruttle.logs"
                $sendFile = Read-Host "Enter 1 to send file via ssh, anything else to proceed"
                if($sendFile -eq 1){
                    New-SSHSession -ComputerName '192.168.6.71' -Credential (Get-Credential sys320)
                    Set-SCPFile -Computername '192.168.6.71' -Credential (Get-Credential sys320) `
                    -RemotePath '/home/sys320' -LocalFile "$myDir\wyatt.ruttle.logs"
                    Invoke-SSHCommand -index 0 'ls -l'
                }
            }
            pause
        }
        #List Running services
        elseif($mainMenu -eq 3){
            Get-Service | Where-Object {$_.Status -eq "Running"}
            pause
        }
        #Option to quit
        elseif($mainMenu -eq 'e'){
            write-host "Goodbye!"
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