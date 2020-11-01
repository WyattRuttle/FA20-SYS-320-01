# Storyline: Create a script that exports list of running processes and running services into separate files
# Where to save CSV
$myDir = "C:\Users\Admin\Documents\SYS-330\Files"

#Running processes
Get-Process | Out-File -FilePath "$myDir\runningProc.csv"

#Running services
Get-Service | Out-File -FilePath "$myDir\runningSer.csv"
