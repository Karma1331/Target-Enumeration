#written for fun & learning, by a noob.
read -p "Who's the target? " target
read -p "Where should we place target directory? " outPath

mkdir $outPath/$target
cd $outPath/$target

nmap -sV -oX nmap.xml $target

openPort=( $(grep -oP '(?!portid=")[0-9]*(?="><state state="open")' nmap.xml ))
#didn't RTFM and don't need it...grabs the service name -> svcName=( $(grep -oP '(?<=product=").*?(?=")' nmap.xml ))
#didn't RTFM and don't need it...grabs service version  -> svcVersion=( $(grep -oP '(?<=version=")\S*?(?=")' nmap.xml ))

#scan for known vuln's based on services from nmap
searchsploit -v --nmap nmap.xml >> searchsploit.txt

for port in "${openPort[@]}"
do
	#web port scanning nmap -> gobuster -> eyewitness	
	echo "Port $port"
	case $port in
		80) 
			echo "http://$target" >> gobuster.txt
			gobuster dir -u http://$target -w /usr/share/wordlists/dirb/common.txt -q -n -e >> gobuster.txt
			eyewitness -f gobuster.txt -d eyewitness --web --no-prompt
		;;
		443) 
			echo "https://$target" >> gobuster.txt
			gobuster dir -u https://$target -w /usr/share/wordlists/dirb/common.txt -q -n -e -k >> gobuster.txt
			eyewitness -f gobuster.txt -d eyewitness --headless --no-prompt
		;;
		8000) 
			echo "http://$target:8000" >> gobuster.txt
			gobuster dir -u http://$target:8000 -w /usr/share/wordlists/dirb/common.txt -q -n -e >> gobuster.txt
			eyewitness -f gobuster.txt -d eyewitness --web --no-prompt
		;;
		8080) 
			echo "http://$target:8080" >> gobuster.txt
			gobuster dir -u http://$target:8080 -w /usr/share/wordlists/dirb/common.txt -q -n -e >> gobuster.txt
			eyewitness -f gobuster.txt -d eyewitness --web --no-prompt
		;;
		8500) 
			echo "http://$target:8500" >> gobuster.txt
			gobuster dir -u http://$target:8500 -w /usr/share/wordlists/dirb/common.txt -q -n -e >> gobuster.txt
			eyewitness -f gobuster.txt -d eyewitness --web --no-prompt
		;;
	esac
done
