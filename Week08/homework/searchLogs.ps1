# Storyline: Review the Security Event Log
# Directory to save files:
$myDir = "C:\Users\Admin\Documents\SYS-330\Files"

#List all the available Windows Event Logs
Get-EventLog -list 

#Create a prompt to allow user to select the log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"
$searchTerm = Read-Host -Prompt "Please write the term you would like to search"
#Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "$searchTerm"} | export-csv -NoTypeInformation -Path "$myDir\securityLogs.csv"
