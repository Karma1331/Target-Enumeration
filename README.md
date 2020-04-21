Make sure you have the following applications installed & configured:
  1. Nmap
  2. Searchsploit
  3. GoBuster
  4. Eyewitness
  5. Ldapsearch
  6. Smbclient
  7. Showmount

This project serves two purposes:
  1. Automate the typical steps taken when enumerating a target.
  2. Learn more about scripting and having fun.
  
Usage:
  1. Navigate to the directory that holds script
  2. Add execution to script = chmod +x sma.sh
  3. Run script = ./sma.sh
  4. Target Name? = name you'd like to refer to host as
  5. Target IP? = IP address of host
  6. Where should we place the target directory? = Path where directory to hold results should be created
  7. Grab some coffee or a coke
  8. Review results
  9. Go get 'em!
  
Flow of script: 
  1. Adds target to /etc/hosts for you.
  2. In-depth nmap scan.
  2. Searchsploit services names & versions, output saved as searchsploit.txt
  3. GoBuster if webport is open to find subdirectories using default common.txt wordlist, output saved as gobuster.txt
  4. Eyewitness to take screenshots of all pages GoBuster, output saved as Eyewitness/reports.html
  5. Smbclient checks if anonymous shares are open >> smbclient.txt
  6. Query LDAP for recon >> nmap-ldap.txt
  7. LDAPsearch to pull hashes and user info >> ldap-findings.txt 
  8. List nfs mount points >> nfsmount.txt
