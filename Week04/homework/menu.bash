#!/bin/bash

# Storyline: Menu for admin, VPN, and Security functions
function invalid_opt(){
echo ""
echo "Invalid option"
echo ""
sleep 2
}
function menu() {
	#clears the screen
	clear

	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		1) admin_menu
		;;
		2) security_menu
		;;
		3) exit 0
		;;
		*)
			invalid_opt
			admin_menu
		;;
	esac
}
function admin_menu(){
	clear
	echo "[L]ist Running Processes"
    echo "[N]etwork Sockets"
	echo "[V]PN Menu"
    echo "[4] Exit"
	read -p "Please enter a choice above: " choice
	case "$choice" in
		L|l) ps -ef |less
		;;
		N|n) netstat -an --inet |less
		;;
		V|v) vpn_menu
		;;
		4) exit 0
		;;
		*)
			invalid_opt
		;;
	
	esac
admin_menu
}

function vpn_menu() {
	clear
	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit"

	read -p "Please select an option: " choice

	case "$choice" in

		A|a) 
	 	bash peer.bash
	 	tail -6 wg0.conf |less
		;;
		D|d) #create a prompt for the user
		# Call the manage-user.bash
		# pass the proper switches and argument to delete the user

		;;
		B|b) admin_menu
		;;
		M|m) menu
		;;
		E|e) exit 0
		;;
		*)
			invalid_opt
		;;

	esac
vpn_menu
}
function security_menu() {
	echo "[L]ist open network sockets"
	echo "[C]eck if any user besides root has a UID of 0"
	echo "[S]ee the last 10 logged in users"
	echo "[D]isplay currently logged in users"
	echo "[B]lock List Menu"
	echo "[E]xit"
	read -p "Please select an option: " choice
	case "$choice" in 
		L|l)
		ss -pl |less
		;;
		C|c)id -nu 0
		;;
		S|s) 
		last -n 10 $USER |less
		;;
		D|d)
		w -s
		;;
		E|e) exit 0
		;;
		B|b) block_menu
		;;
		*)
		invalid_opt
		;;
	esac
security_menu
}
function block_menu() {
	echo "[C]isco blocklist generator"
	echo "[D]omain URL blocklist generator"
	echo "[N]etscreen blocklist generator"
	echo "[W]indows blocklist generator"
	echo "[E]xit"
	read -p "Please select an option: " choice
	case "$choice" in
		C|c) bash parse-threat-intell.bash -c
		;;
		D|d) bash parse-threat-intell.bash -p
		;;
		N|n) bash parse-threat-intell.bash -n
		;;
		W|w) bash parse-threat-intell.bash -w
		;;
		E|e) exit 0
		;;
	esac
block_menu
}
#call the main function
menu
