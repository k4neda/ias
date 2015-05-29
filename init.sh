#!/bin/bash


# FIX long URL (reposition), check PING

NC='\033[0m'
RED="\E[0;41m\033[1m"
ORANGE="\E[30;43m\033[30m"
GREEN="\E[30;42m\033[30m"
FONTGREEN="\033[0;32m"

NETWORK="0"
SQLMAP="0"
NMAP="0"
TOR="0"

TARGET=""
IP=""
OS=""

function main(){
	
	while true
	do
	
		if [ -z "$TARGET" ]; then
			echo -e   "\033[2J\033[0;1H"
			echo -e   "\t\t\t        ___       __        _______   "; 
			echo -e   "\t\t\t        | |      /  \\      |  _____| \t"
			echo -e   "\t\t\t        | |     / /\ \\     | |_____  "; 
			echo -e   "\t\t\t        | |    / /__\ \\    |_____  | \t"
			echo -e   "\t\t\t        | |   / _____  \\    _____| | "; 
			echo -e   "\t\t\t        | |  / /      \ \\  |       | \t"
			echo -e   "\t\t\t        ############################  "; 
			echo -e   "\t\t\t           increased attack speed     \t"
			echo -e   ""
			echo -e   "${FONTGREEN}------------------------------------------------------------------------------------${NC}"
		
			echo -e   ""
			echo -ne "Target URL:  "
			read INPUT
			TARGET="$INPUT"
			IP=$(ping -q -c 3 -w 2 $TARGET | grep -oP '(?:[0-9]{1,3}\.){3}[0-9]{1,3}')
		fi
	
		echo -e   "\033[2J\033[0;1H"
		echo -e   "\t___       __        _______   "; 
		echo -en  "\t| |      /  \\      |  _____| \t"; initstatus $NETWORK network
		echo -e   "\t| |     / /\ \\     | |_____  "; 
		echo -en  "\t| |    / /__\ \\    |_____  | \t"; initstatus $SQLMAP sqlmap
		echo -e   "\t| |   / _____  \\    _____| | "; 
		echo -en  "\t| |  / /      \ \\  |       | \t"; initstatus $NMAP nmap
		echo -e   "\t############################  "; 
		echo -en  "\t   increased attack speed     \t"; initstatus $TOR tor
		echo -e   ""
		echo -e   "${FONTGREEN}------------------------------------------------------------------------------------${NC}"
		echo -e "[${GREEN}  ${NC}] Target: $TARGET";
		echo ""
		echo -e "[${GREEN}  ${NC}] IP    : $IP"
		echo ""
		echo -e   "${FONTGREEN}------------------------------------------------------------------------------------${NC}"
		echo -en "IAS --> "
		read INPUT
		
		

	done
	
}

function init(){
		
	#ping 8.8.8.8
	ping -q -c 3 -w 2 8.8.8.8
	if [ $? == "1" ]; then
		echo -e "\033[2J\033[0;1H"
		echo -e "${GREEN}[!]${NC} network ok"
		NETWORK="1"
	else
		echo -e "\033[2J\033[0;1H"	
		echo -e "${RED}[critical]${NC} connection failed"
		NETWORK="0"
	fi
	
	#check nmap
	bincheck nmap
	
	#check sqlmap
	bincheck sqlmap
	
	#check tor
	service tor status 1>/dev/null
	if [ $? == "0" ]; then
		echo -e "${GREEN}[!]${NC} tor service running"
		TOR="1"
	else
		which tor 1>/dev/null
		if [ $? == "0" ]; then
			echo -e "${ORANGE}[warning]${NC} tor not running"
			TOR="2"
		else
			echo -e "${RED}[critical]${NC} tor not found"
		fi
	fi
}

function bincheck()
{
	which $1 1>/dev/null
	if [ $? == "0" ]; then
		echo -e "${GREEN}[!]${NC} $1 detected"
		
		if [ $1 == "nmap" ]; then
			NMAP=1
		elif [ $1 == "sqlmap" ]; then
			SQLMAP=1
		fi
	else
		echo -e "${RED}[critical]${NC} $1 not found"
	fi
}

function basics()
{
	if [ $1 == "ip" ] && [ -z "$IP" ]; then
		IP=$(ping -q -c 3 -w 2 $TARGET | grep -oP '(?:[0-9]{1,3}\.){3}[0-9]{1,3}')
		echo -en "[${GREEN}  ${NC}] IP: $IP"
	
	elif [ $1 == "os" ] && [ -z "$OS" ]; then
		OS=$(nmap -Pn -p 80 -O $TARGET | grep -oP '(?<=OS details: ).*(?=)')
		echo -en "[${GREEN}  ${NC}] OS: $OS"
	fi
}

function initstatus()
{
	if [ $1 == "0" ]; then
		if [ "$2" == "network" ]; then
			echo -e "\t[${RED}  ${NC}] $2 [check your network settings!]"
		elif [ "$2" == "nmap" ]; then
			echo -e "\t[${RED}  ${NC}] $2 [sudo apt-get install nmap]"
		elif [ "$2" == "sqlmap" ]; then
			echo -e "\t[${RED}  ${NC}] $2 [sudo apt-get install sqlmap]"
		elif [ "$2" == "tor" ]; then
			echo -e "\t[${RED}  ${NC}] $2 [sudo apt-get install tor]"
		fi
	elif [ $1 == "1" ]; then
		echo -e "\t[${GREEN}  ${NC}] $2"
	elif [ $1 == "2" ]; then
		echo -e "	[${ORANGE}  ${NC}] $2 stopped [sudo service tor start]"
	fi	
	
}

init
#read -n 1 -s 
main
