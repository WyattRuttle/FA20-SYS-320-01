# Storyline: view the event logs, check for a valid log, and print the results
function select_log(){
    cls
    # List all event logs
    $theLogs = Get-EventLog -list | select Log
    $theLogs | Out-Host
    
    # Initialize the array to store the logs
    $arrLog = @()
    foreach ($tempLog in $theLogs){
        #add each log to the array
        $arrLog += $tempLog
    }
    #$arrLog
    #Prompt for user input 
    $readLog = read-host -Prompt "Please enter a log from the list above or 'q' to quit the program"

    #Check if the user wants to quit
    if ($readLog -match "^[qQ]$"){
        break
    }
    log_check -logToSearch $readLog 
}
function log_check() {
    # String user types in select_log function
    param([string]$logToSearch)
    $theLog = "^@{Log=" + $logToSearch + "}$"

    # Search the array for the exact hashtable string
    if ($arrLog -match $theLog){
        write-host -BackgroundColor Green -ForegroundColor White "Please wait, it may take a few moments to retrieve log entries"
        sleep 2

        # Call the function to view the log
        view_log -logToSearch $logToSearch
    } else {
        write-host -BackgroundColor Red -ForegroundColor White "The log specified it doesn't exist."
        sleep 2
        select_log
    }
}
function view_log(){
    cls

    # String the user types in within the log_check function
    #Param([string]$logToSearch)

    #Get the logs
    Get-EventLog -Log $logToSearch -Newest 10 -after "1/18/2020"

    # Pause the screen and wait until the user is ready to proceed
    read-host -Prompt "Press enter when you are done."

    # Go back to select_log
    select_log
}

#Run the select_log as the first function
select_log