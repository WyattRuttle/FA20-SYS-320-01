#!/bin/bash
#Storyline: Create firewall rules from parsed IP files
#wget https://rules.emergingthreats.net/blockrules/emerging-compromised.rules -O /tmp/emerging-compromised.rules
#egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-compromised.rules | sort -u | tee threatIPs.txt
function help (){
	echo "You can also use the following options:"
	echo " -i iptables"
	echo " -c Cisco"
	echo " -n Netscreen"
	echo " -w Windows Firewall"
	echo " -m Mac OS X"
	echo " -p Parse targetedthreats.csv"
}
#Apache Log Filename variable
read -p "Please enter an apache log file." lFile
if [[ ! -f ${lFile} ]]
then
	echo "File doesn't exist"
	exit 1
else
	awk ' { print $1 } ' ${lFile} |sort -u | tee badIPAdrs.txt 
fi
echo "${lFile}"
#Compromised rule file
tFile="/tmp/emerging-compromised.rules"
echo "${tFile}"
#Check if the threat file exists
#if [[ -f "${tFile}" ]]
#then
		#Prompt to download again
#		echo "The file ${tFile} exists."
#		echo -n "Do you want to download it again? [y/N]"
#		read to_download
#
#		if [[ "${to_download}" == "N" || "${to_download}" == "" ]]
#		then
#				#echo "Exit..."
#				exit 1
#		elif [[ "${to_download}" == "y" ]]
#		then
#				echo "Downloading the threat file again..."
#				wget https://rules.emergingthreats.net/blockrules/emerging-compromised.rules -O /tmp/emerging-compromised.rules
#				egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /tmp/emerging-compromised.rules | sort -u | tee badIPAdrs.txt
		#if the admin doesnt specify y/n then error
#else
#				echo "Invalid value"
#				exit 1	
#		fi
#fi
#Use the bash getopts function to create switches for iptables, cisco, netscreen, windows firewall, and Mac OS X. Based on their selection, create an inbound drop rule for the respective firewall.
while getopts 'hicnwmp:' OPTION ; do
	case "$OPTION" in

		h) help
		;;
		i)
			for eachIP in $(cat badIPAdrs.txt)
			do
#				echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPAdrs.iptables
			done
		exit 0
		;;
		c) 
			for eachIP in $(cat badIPAdrs.txt)
			do
#				echo "access-list 1 deny ${eachIP}" | tee -a startup.cfg 
			done
		exit 0
		;;
		n)
			for eachIP in $(cat badIPAdrs.txt)
			do 
				echo "set firewall filter limit-mgmt-access term block_non_manager from source-address ${eachIP}" |tee -a badIPAdrs.iptables
			done
		exit 0
		;;
		w)
			for eachIP in $(cat badIPAdrs.txt)
			do
				echo "netsh advfirewall firewall add rule name="BLOCKED IP" interface=any dir=in action=block remoteip= ${eachIP}" | tee -a fw-rules.wfw
			done 
		exit 0
		;;
		m)
			for eachIP in $(cat badIPAdrs.txt)
			do
				echo "block in from ${eachIP} to any" | tee pf.conf
			done
		exit 0
		;;
		p)
			wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv
			awk -F, '{ print $4 }' /tmp/targetedthreats.csv | sort -u | tee badDomains.txt
			echo "class-map match-any BAD_URLS" | tee URL.cfg
				for eachDomain in $(cat badDomains.txt)
				do
					echo "match protocol http host ${eachDomain}" | tee -a URL.cfg 
				done
		exit 0
		;;
		*)	help
			#invalid_opt
		;;
	esac
done
