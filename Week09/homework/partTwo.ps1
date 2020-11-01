# Storyline: Create a script that grabs network information
# Task: Grab the network adapter information using the WMI class
# Where to save CSV
$myDir = "C:\Users\Admin\Documents\SYS-330\Files"
# Get the IP address, default gateway, and the DNS servers
Get-WMIObject -Class Win32_NetworkAdapterConfiguration -ComputerName . |
# Add to CSV
Where-Object -FilterScript {$_.IPEnabled} |
                              #@{N="IPAddress"; E={$_.IpAddress[0]}} is used to grab item from array since there are multiple outputs in the console
    Select-Object DNSHostName, @{N="IPAddress"; E={$_.IpAddress[0]}}, DefaultIPGateway, DNSDomain| Export-Csv -Path "$myDir\adapterConfig.csv" -NoTypeInformation