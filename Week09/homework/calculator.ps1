# Storyline: program that can start and stop the Windows Calculator only using Powershell
#main menu for calc start stop
function mainMenu {
    $mainMenu = 'open'
    while($mainMenu -ne 'E'){
        Clear-Host
        Write-Host -ForegroundColor Yellow "===== Calculator Menu ====="
        Write-Host " "
        Write-Host "1: Open Calculator"
        Write-Host " "
        Write-Host "2: Close Calculator"
        Write-Host " "
        Write-Host "[E]xit"
        Write-Host " "
        $mainMenu = Read-Host "Enter choice"
        # Launch sysAdminMenu
        if($mainMenu -eq 1){
            Start-Process -FilePath "calc.exe"
        }
        # Launch securityMenu
        if($mainMenu -eq 2){
            Stop-Process -Name "calculator"
        }
    }
}
mainMenu