# Storyline: Review the Security Event Log and save to .csv file
# Directory to save files:
$myDir = "C:\Users\Admin\Documents\SYS-330\Files"

#List all the available Windows Event Logs
Get-EventLog -list 

#Prompt to allow user to select the log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"
#Prompt to allow user to select search term in log
$searchTerm = Read-Host -Prompt "Please write the term you would like to search"

#Print the results for the log and save to csv file
Get-EventLog -LogName $readLog -Newest 40 | Where {$_.Message -ilike "*$searchTerm*" } | export-csv -NoTypeInformation -Path "$myDir\securityLogs.csv"
