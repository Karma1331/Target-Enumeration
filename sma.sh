#!/bin/bash

read -p "Target Name? " targetName
read -p "Target IP? " targetIP
read -p "Where should we place target directory? " outPath

if grep -q "$targetIP $targetName" /etc/hosts;
then
	echo "Host record exists"
else
	echo "$targetIP $targetName" >> /etc/hosts
fi

mkdir $outPath/$targetName
cd $outPath/$targetName

nmap -vv -Pn -sC -sV -p- -oX nmap.xml -oN nmap.txt $targetName
#TODO build an option for quick and comprehensive nmap & wordlists

#Grabs open ports from Nmap
openPort=( $(grep -oP '(?!portid=")[0-9]*(?="><state state="open")' nmap.xml ))

#scan for known vulnerabilities based on nmap
searchsploit -v --nmap nmap.xml >> searchsploit.txt

for port in "${openPort[@]}"
do
	#web port scanning nmap -> gobuster -> eyewitness
	echo "Enumerating port $port"
	case $port in
		80) 
			echo "http://$targetName" >> gobuster.txt
			gobuster dir -qneft 30 -x .php,.html --timeout 15s -u http://$targetName -w /usr/share/wordlists/dirb/big.txt >> gobuster.txt
			eyewitness -f gobuster.txt -d eyewitness --web --threads 30 --resolve --no-prompt
		;;
		139)
			smbclient -gL $targetIP -N >> smbclient.txt
		;;
		389)
			nmap -p389 --script ldap-search -v0 -oN nmap-ldap.txt $targetIP
			domain=( $(grep -oP '((?<=Context: ).*)' nmap-ldap.txt ))
			ldapsearch -x -p 389 -h $targetIP -b "$domain" "objectclass=person" >> ldap-findings.txt
		;;
		443) 
			echo "https://$targetName" >> gobuster.txt
			gobuster dir -qnefkt 30 -x .php,.html --timeout 15s -u https://$targetName -w /usr/share/wordlists/dirb/big.txt >> gobuster.txt
			eyewitness -f gobuster.txt -d eyewitness --headless --resolve --no-prompt
		;;
		445)
			smbclient -gL $targetIP -p 445 -N >> smbclient.txt
		;;
		2049)
			showmount -e $targetIP >> nfsmount.txt
		;;
		8000) 
			echo "http://$targetName:8000" >> gobuster.txt
			gobuster dir -qneft 30 -x .php,.html --timeout 15s -u http://$targetName:8000 -w /usr/share/wordlists/dirb/big.txt >> gobuster.txt
			eyewitness -f gobuster.txt -d eyewitness --web --threads 30 --resolve --no-prompt
		;;
		8080) 
			echo "http://$targetName:8080" >> gobuster.txt
			gobuster dir -qneft 30 -x .php,.html --timeout 15s -u http://$targetName:8080 -w /usr/share/wordlists/dirb/big.txt >> gobuster.txt
			eyewitness -f gobuster.txt -d eyewitness --web --threads 30 --resolve --no-prompt
		;;
		8500) 
			echo "http://$targetName:8500" >> gobuster.txt
			gobuster dir -qneft 30 -x .php,.html --timeout 15s -u http://$targetName:8500 -w /usr/share/wordlists/dirb/big.txt >> gobuster.txt
			eyewitness -f gobuster.txt -d eyewitness --web --threads 30 --resolve --no-prompt
		;;
	esac
done
