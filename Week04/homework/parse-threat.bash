#!/bin/bash

#Storyline: Extract IPs from emerging threats.net and create a firewall ruleset 

#alert tcp [5.134.128.0/19,5.180.4.0/22,5.183.60.0/22,5.188.10.0/23,23.92.80.0/20,24.233.0.0/19,27.126.160.0/20,27.146.0.0/16,31.14.65.0/24,31.14.66.0/23,31.40.164.0/22,36.0.8.0/21,36.37.48.0/20,36.116.0.0/16,36.119.0.0/16,37.156.64.0/23,37.156.173.0/24,37.252.220.0/22,41.77.240.0/21,41.93.128.0/17] any -> $HOME_NET any (msg:"ET DROP Spamhaus DROP Listed Traffic Inbound group 1"; flags:S; reference:url,www.spamhaus.org/drop/drop.lasso; threshold: type limit, track by_src, seconds 3600, count 1; classtype:misc-attack; flowbits:set,ET.Evil; flowbits:set,ET.DROPIP; sid:2400000; rev:2777; metadata:affected_product Any, attack_target Any, deployment Perimeter, tag Dshield, signature_severity Minor, created_at 2010_12_30, updated_at 2020_09_20;)

# Regex to extract the networks

#5.            134.           128.           0/             19
#wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -o /tmp/emerging-drop.suricata.rules

egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

# Create a firewall ruleset
for eachIP in $(cat badIPs.txt)
do
	echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
done
