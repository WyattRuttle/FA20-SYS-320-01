#! /bin/bash

# Storyline: Menu that parses Apache log
#Read in file

#Arguments using the position, they start at $1
APACHE_LOG="$2"
#check if file exists
if [[ ! -f ${APACHE_LOG} ]]
then
		echo "Please specify the path to a log file."
		exit 1
fi

# Looking for web scanners
function parses (){
	sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
	egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
	awk ' BEGIN { format = "%-15s %-20s %-6s %-6s %-5s %s\n" 
					printf format, "IP", "Date", "Method", "Status", "Size", "URI"
					printf format, "--", "----", "------", "------", "----", "---"}
	{ printf format, $1, $4, $6, $9, $10, $7 }'
}
# allows user to print the results to console, save as a file, or create firewall rule 
while getopts 'psc' OPTION ; do
    case "$OPTION" in
        p) parses
		;;
		s)
			echo "Enter filename: "
			read parseFile
			if [[ -f "${parseFile}.txt" ]]
			then 
				echo "The file ${parseFile} exists."
				echo -n "Do you want to overwrite it? [y/N]"
				read to_overwrite
				if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" ]]
				then
					echo "Exit..."
					exit 0
				elif [[ "${to_overwrite}" == "y" ]]
				then 
					echo "Creating the log file..."
				else
					echo "Invalid value"
					exit 1
				fi
			fi
			parses > "${parseFile}.txt"
        ;;
		c) bash parse-threat-intell.bash
		;;
    esac
done
