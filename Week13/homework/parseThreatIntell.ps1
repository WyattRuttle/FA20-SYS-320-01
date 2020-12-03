# Array of websites containg threat intell
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

#Loop through the URLS for the rules list
foreach ($u in $drop_urls){
    #Extract the filename
    $temp = $u.split("/")
    #The last element in the array plucked off is the filename
    $file_name = $temp[-1]
    if (Test-Path $file_name){
        continue
    } else {
        #Download the rules list
        Invoke-WebRequest -Uri $u -outFile $file_name
    } #Close if statement
} #Close the foreach loop
#Array containg the filename
$input_paths = @('.\compromised-ips.txt','.\emerging-botcc.rules')
#Extract the IP addresses
$regex_drop = "\d{1,3}(\.\d{1,3}){3}"
#'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

#Append the IP addresses to the temporary IP list
Select-String -Path $input_paths -Pattern $regex_drop | `
ForEach-Object { $_.Matches } | `
ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
Out-File -FilePath "ips-bad.tmp"

#Ask what type of firewall rule to create from bad IPs file
$ruleType = Read-Host "Enter choice for firewall rule typ (IPTable, Cisco, Windows)"
switch ( $ruleType )
{
    #Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
    #iptables -A INPUT -s 108.191.2.72 -j DROP
    #IPTables L7 ruleset
    IPTable
    {
        (Get-Content -Path ".\ips-bad.tmp") | ForEach-Object `
        { $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP" } | `
        Out-File -FilePath "iptables.bash"
    }
    #Cisco ruleset
    Cisco
    {
        (Get-Content -Path ".\ips-bad.tmp") | ForEach-Object `
        { $_ -replace "^", "deny tcp host" -replace "$"} | `
        Out-File -FilePath "badIPs.txt"
    }
    #Windows firewall ruleset
    Windows
    #netsh advfirewall firewall add rule name="Blockit" protocol=any dir=in action=block remoteip=
    {
        (Get-Content -Path ".\ips-bad.tmp") | ForEach-Object `
        { $_ -replace "^", "netsh advfirewall firewall add rule name='badIPs' protocol=any dir=in action=block remoteip=" -replace "$"} | `
        Out-File -FilePath "badIPs.wfw"
    }
    default { 'Not sure, maybe a spelling error?' }
}
