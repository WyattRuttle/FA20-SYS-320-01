@@ -0,0 +1,100 @@
#!/bin/bash

#Storyline: Create peer VPN configuration file

#What is peer's name
echo -n "What is the peer's name? "
read the_client

#Filename variable
pFile="${the_client}-wg0.conf"
echo "${pFile}"
#Check if the peer file exists
if [[ -f "${pFile}" ]]
then
	#Prompt if we need to overwrite the file
	echo "The file ${pFile} exists."
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
#Generate a private key
p="$(wg genkey)"

#Generate public  key
clientPub="$(echo ${p} | wg pubkey)"

# generate a preshared key
pre="$(wg genpsk)"

# 10.254.132.0/24,172.16.28.0/24 192.199.97.163:4282 DPJihHtdQ80qLbXFz6QH5hJL31aTsKrV++sFfVJYi3A= 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0

#Endpoint
end="$(sudo head -1 /etc/wireguard/wg0.conf | awk ' { print $3 } ')"
#Server Public Key
pub="$(sudo head -1 /etc/wireguard/wg0.conf | awk ' { print $4 } ')"
#DNS Servers
dns="$(sudo head -1 /etc/wireguard/wg0.conf | awk ' { print $5 } ')"
#MTU
mtu="$(sudo head -1 /etc/wireguard/wg0.conf | awk ' { print $6 } ')"
#KeepAlive
keep="$(sudo head -1 /etc/wireguard/wg0.conf | awk ' { print $7 } ')"
#ListenPort
lport="$(shuf -n1 -i 40000-50000)"
#Default routes for VPN
routes="$(sudo head -1 /etc/wireguard/wg0.conf | awk ' {print $8} ')"
#Create a client configuration file
: '
[Interface]
Address = 10.254.132.100/24
DNS = 8.8.8.8,1.1.1.1
ListenPort = 48203
MTU = 1280
PrivateKey = PEER_A_PRIVATE_KEY
[Peer]
AllowedIPs = 0.0.0.0/0
PersistantKeepAlive = 120
PublicKey = PEER_B_PUBLIC_KEY
PresharedKey = PEER_A-PEER_B-PRESHARED_KEY
Endpoint =  198.199.97.163:4282
'
#end comment
echo " [Interface]
Address = 10.254.132.100/24
DNS = ${dns}
ListenPort =  ${lport}
MTU = ${mtu}
PrivateKey = ${p}
[Peer]
AllowedIPs = ${routes}
PersistantKeepalive = ${keep}
PublicKey = ${pub}
PresharedKey = ${pre}
Endpoint =  ${end}
" > ${pFile}
#add our peer configuration to the server config
echo "
#wyatt begin
[Peer]
Publickey = ${clientPub}
PresharedKey = ${pre}
AllowedIPs = 10.254.132.100/32
#wyatt end" | tee -a wg0.conf
echo " 
sudo cp wg0.conf /etc/wireguard
sudo wg addconf wg0<(wg-quick strip wg0)
"
