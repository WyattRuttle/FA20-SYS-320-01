@@ -0,0 +1,60 @@
#!/bin/bash
# Storyline: Script to create a wireguard server
#Filename variable
sFile="wg0.conf"
#Check if the peer file exists
#Check if the peer file exists
if [[ -f "${sFile}" ]]
then
    #Prompt if we need to overwrite the file
    echo "The file ${sFile} exists."
    echo -n "Do you want to overwrite it? [y/N]"
    read to_overwrite

    if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" ]]
    then
        echo "Exit..."
        exit 0
    elif [[ "${to_overwrite}" == "y" ]]
    then
        echo "Creating the wireguard configuration file..."
    #if the admin doesnt specify y/n then error
    else
        echo "Invalid value"
        exit 1
    fi
fi
#Create a private key
p="$(wg genkey)"
#Create a public key
pub="$(echo ${p} | wg pubkey)"
#Set the addresses
address="10.254.132.0/24,172.16.28.0/24"
# Set Server IP Addresses
Serveraddress="10.254.132.1/24,172.16.28.1/24"

#Set the Listen port
lport="4282"

#Create the format for the client configuration options
peerInfo="# ${address} 192.199.97.163:4282 ${pub} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"


: '
'

echo "${peerInfo}
[Interface]
Address = ${Serveraddress}
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = ${lport}
PrivateKey = ${p}
" > wg0.conf
