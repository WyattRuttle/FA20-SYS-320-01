#!/bin/bash

# Script to perform local security checks
# Check if expected value is equal to current value
function checks() {

		if [[ $2 != $3 ]]
		then 
				echo -e  "\e[1;31mThe $1 is not compliant. The current policy should be: $2, the current value is: $3.\e[0m"
				echo "REMEDIATION"
				echo "Edit: $4"
				echo "Set: $5"
				echo "Run: $6"
		else
				echo -e "\e[1;32mThe $1 is compliant. The current value is: $3.\e[0m"
		fi
}

# Check the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Max Days" "365" "${pmax}" "/etc/login.defs" "PASS_MAX_DAYS: 365" ""

# Check the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Min Days" "14" "${pmin}" "/etc/login.defs" "PASS_MIN_DAYS: 14" ""

#Check the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ') 
checks "Password Warn Age" "7" "${pwarn}" "/etc/login.defs" "PASS_WARN_AGE: 7" ""

# Check the SSH UsePam configuration
chkSSHPAM=$(egrep -i "^UsePAM"  /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePAM" "yes" "${chkSSHPAM}"

# Check permissions for users in home directory
for eachDir in $(ls -l /home | egrep '^d' |awk ' { print $3 } ')
do 
		chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
		checks "Home directory ${eachDir}" "drwx------" "${chDir}" "" "" "chmod 705 /home"
done 

# Ensure IP forwarding is disabled
ip_forward_chk=$(egrep -i 'net\.ipv4\.ip_forward' /etc/sysctl.conf | cut -d'=' -f2- )
checks "IP forwarding" "0" "${ip_forward_chk}" "/etc/sysctl.conf" "net.ipv4.ip_forward=0" "sysctl -fw"

#Ensure ICMP redirects are not accepted
#Two cut commands below because the output originally gave space before the number
icmp_redir_chk=$(egrep -i "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf | cut -d'=' -f2- | cut -d' ' -f2)
checks "ICMP redirect" "0" "${icmp_redir_chk}" "/etc/sysctl.conf" "net.ipv4.conf.all.send_redirects = 0" "sysctl -w net.ipv4.conf.all.send_redirects=0"

#Ensure permissions on /etc/crontab are configured
cronTab_chk=$(crontab -u root -l | grep aide)
checks "Crontab" "crontab for root" "$cronTab_chk" "/etc/crontab" "0 5 * * * /usr/bin/aide.wrapper --config /etc/aide/aide.conf --check" "crontab -u root -e"

#Ensure permissions on /etc/cron.hourly are configured
cronHourly_chk=$(stat /etc/cron.hourly | sed '4q;d')
checks "cron.hourly" "Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)" "$cronHourly_chk" "" "" "chown root:root /etc/cron.hourly"

#Ensure permissions on /etc/cron.daily are configured
cronDaily_chk=$(stat /etc/cron.daily | sed '4q;d')
checks "cron.daily" "Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)" "$cronDaily_chk" "" "" "chown root:root /etc/cron.daily"

#Ensure permissions on /etc/cron.weekly are configured
cronWeekly_chk=$(stat /etc/cron.weekly | sed '4q;d')
checks "cron.weekly" "Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)" "$cronDaily_chk" "" "" "chown root:root /etc/cron.weekly"

#Ensure permissions on /etc/cron.monthly are configured
cronMonthly_chk=$(stat /etc/cron.monthly | sed '4q;d')
checks "cron.monthly" "Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)" "$cronMonthly_chk" "" "" "chown root:root /etc/cron.monthly"

#Ensure permissions on /etc/passwd are configured
passwd_chk=$(stat /etc/passwd | sed '4q;d')
checks "/etc/passwd" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "$passwd_chk" "" "" "chown root:root /etc/passwd"

#Ensure permissions on /etc/shadow are configured
shadow_chk=$(sudo grep ^root:[*\!]: /etc/shadow)
checks "/etc/shadow" "" "$shadow_chk" "" "" "passwd root"

#Ensure permissions on /etc/group are configured
group_chk=$(stat /etc/passwd | sed '4q;d')
checks "/etc/group" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "$group_chk" "" "" "chown root:root /etc/group"

#Ensure permissions on /etc/gshadow are configured
gshadow_chk=$(stat /etc/gshadow | sed '4q;d')
checks "/etc/gshadow" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "$gshadow_chk" "" "" "chown root:shadow /etc/gshadow"

#Ensure permissions on /etc/passwd- are configured
passwdl_chk=$(stat /etc/passwd- | sed '4q;d')
checks "/etc/passwd-" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)" "$passwdl_chk" "" "" "chown root:shadow /etc/passwd-"

#Ensure permissions on /etc/gshadow- are configured 
shadowl_chk=$(stat /etc/shadow- | sed '4q;d')
checks "/etc/gshadow-" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "$shadowl_chk" "" "" "chown root:shadow /etc/shadow-"

#Ensure no legacy "+" entries exist in /etc/passwd
legacyPasswd_chk=$(grep '^\+:' /etc/passwd)
checks "Legacy '+' entries in /etc/passwd" "" "$legacyPasswd_chk" "/etc/passwd" "Remove any legacy '+' entries" ""

#Ensure no legacy "+" entries exist in /etc/shadow
legacyShadow_chk=$(sudo grep '^\+:' /etc/shadow)
checks "Legacy '+' entries in /etc/shadow" "" "$legacyShadow_chk" "/etc/shadow" "Remove any legacy '+' entries" ""
#Ensure no legacy "+" entries exist in /etc/group
legacyGroup_chk=$(sudo grep '^\+:' /etc/group)
checks "Legacy '+' entries in /etc/shadow" "" "$legacyGroup_chk" "/etc/group" "Remove any legacy '+' entries" ""

#Ensure root is the only UID 0 account
root_chk=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
checks "Root is the only UID 0 account" "root" "$root_chk" "Remove any users other than root with UID 0 or assign them a new UID if appropriate."
