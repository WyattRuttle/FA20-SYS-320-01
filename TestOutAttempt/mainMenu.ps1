function mainMenu {
    $mainMenu = 'open'
    while($mainMenu -ne 'E'){
        Clear-Host
        Write-Host -ForegroundColor Yellow "===== Main Menu ====="
        Write-Host " "
        Write-Host "1: System Admin Menu"
        Write-Host " "
        Write-Host "2: Security Admin Menu"
        Write-Host " "
        Write-Host "[E]xit"
        Write-Host " "
        $mainMenu = Read-Host "Enter choice"
        # Launch sysAdminMenu
        if($mainMenu -eq 1){
            sysAdminMenu
        }
        # Launch securityMenu
        if($mainMenu -eq 2){
            securityMenu
        }
    }
}

function sysAdminMenu {
    $sysAdminMenu = 'open'
    while($sysAdminMenu -ne 'E'){
        Clear-Host
        Write-Host -ForegroundColor Yellow "===== System Admin Menu ====="
        Write-Host " "
        Write-Host "1: List all running processes"
        Write-Host " "
        Write-Host "2: List all running services"
        Write-Host " "
        Write-Host "3: List all installed packages"
        Write-Host " "
        Write-Host "4: List Processor and Disk Info"
        Write-Host " "
        Write-Host "[E]xit"
        Write-Host " "
        $sysAdminMenu = Read-Host "Enter choice"
        # List all running processes
        if($sysAdminMenu -eq 1){
            Clear-Host
            Write-Host -ForegroundColor Yellow "===== Running Processes ====="
            Write-Host " "
            Write-Host "1: Save Output to File"
            Write-Host " "
            Write-Host "2: Specify the process name"
            Write-Host " "
            Write-Host "3: Print to Console"
            Write-Host " "
            $selection = Read-Host "Enter choice"
            switch ($selection)
            {
            '1' {
             $fName = Read-Host "File Name"
             Get-Process | Out-File -FilePath .\$fName.csv
             Get-ChildItem -Path C:\Users\Admin\Documents\$fName.csv -Recurse
             $exists = Test-Path .\$fName.csv
             if ($exists -ne 'true'){
                Write-Host "file does not exist"
            }
            } 
            '2' {
             $procName = Read-Host "Process Name"
             Get-Process -Name $procName
            } 
            '3' {
             Get-Process
            }
            }
            Pause
        }
        # List all running services
        if($sysAdminMenu -eq 2){
            Clear-Host
            Write-Host -ForegroundColor Yellow "===== Running Services ====="
            Write-Host " "
            Write-Host "1: Save Output to File"
            Write-Host " "
            Write-Host "2: Specify the service name"
            Write-Host " "
            Write-Host "3: Print to Console"
            Write-Host " "
            $selection = Read-Host "Enter choice"
            switch ($selection)
            {
            '1' {
             $fName = Read-Host "File Name"
             Get-Service | Out-File -FilePath .\$fName.csv
             Get-ChildItem -Path C:\Users\Admin\Documents\$fName.csv -Recurse
             $exists = Test-Path .\$fName.csv
             if ($exists -ne 'true'){
                Write-Host "file does not exist"
            }
            } 
            '2' {
             $procName = Read-Host "Process Name"
             Get-Service -Name $procName
            } 
            '3' {
             Get-Service
            }
            }
            Pause
        }
        # List all installed packages
        if($sysAdminMenu -eq 3){
            Clear-Host
            Write-Host -ForegroundColor Yellow "===== List all installed packages ====="
            Write-Host " "
            Write-Host "1: Save Output to File"
            Write-Host " "
            Write-Host "2: Specify the service name"
            Write-Host " "
            Write-Host "3: Print to Console"
            Write-Host " "
            $selection = Read-Host "Enter choice"
            switch ($selection)
            {
            '1' {
             $fName = Read-Host "File Name"
             Get-Package | Out-File -FilePath .\$fName.csv
             Get-ChildItem -Path C:\Users\Admin\Documents\$fName.csv -Recurse
             $exists = Test-Path .\$fName.csv
             if ($exists -ne 'true'){
                Write-Host "file does not exist"
            }
            } 
            '2' {
             $procName = Read-Host "Process Name"
             Get-Package -Name $procName
            } 
            '3' {
             Get-Package
            }
            }
            Pause
        }
        # List processor/disk/ information
        if($sysAdminMenu -eq 4){
            Clear-Host
            Write-Host -ForegroundColor Yellow "===== List Processor and Disk Info ====="
            Write-Host " "
            Write-Host "1: Save Output to File"
            Write-Host " "
            Write-Host "2: Specify the service name"
            Write-Host " "
            Write-Host "3: Print to Console"
            Write-Host " "
            $selection = Read-Host "Enter choice"
            switch ($selection)
            {
            '1' {
             $fName = Read-Host "File Name"
             Get-Package | Out-File -FilePath .\$fName.csv
             Get-ChildItem -Path C:\Users\Admin\Documents\$fName.csv -Recurse
             $exists = Test-Path .\$fName.csv
             if ($exists -ne 'true'){
                Write-Host "file does not exist"
            }
            } 
            '2' {
             $procName = Read-Host "Process Name"
             Get-Package -Name $procName
            } 
            '3' {
             Get-Counter
            }
            }
            Pause
        }
    }
}
function securityMenu {
    $securityMenu = 'open'
    while($securityMenu -ne 'E'){
        Clear-Host
        Write-Host -ForegroundColor Yellow "===== Security Admin Menu ====="
        Write-Host " "
        Write-Host "Choice 1"
        Write-Host " "
        Write-Host "Chioce 2"
        Write-Host " "
        Write-Host "[E]xit"
        Write-Host " "
        $securityMenu = Read-Host "Enter choice"
        # Option 1
        if($securityMenu -eq 1){
            Get-Process
            Pause
        }
        # Option 2
        if($securityMenu -eq 2){
            Get-Service
            Pause
        }
    }
}
mainMenu