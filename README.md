Make sure you have the following applications installed & configured:
  1. Nmap
  2. Searchsploit
  3. GoBuster
  4. Eyewitness

This project serves two purposes:
  1. Automate the typical steps taken when enumerating a target.
  2. Learn more about scripting and having fun.
  
Usage:
  1. Navigate to the directory that holds script
  2. Add execution to script = chmod +x sma.sh
  3. Run script = ./sma.sh
  4. Who's the target? = IP or name of host
  5. Where should we place the target directory? = Path where directory to hold results should be created
  6. Grab some coffee or a coke
  7. Review results
  8. Go get 'em!
  
Flow of script: 
  1. Find target's open ports, service names & versions.
  2. Searchsploit services names & versions, output saved as searchsploit.txt
  3. GoBuster if webport is open to find subdirectories using default common.txt wordlist, output saved as gobuster.txt
     a. Eyewitness to take screenshots of all pages GoBuster found including root-directory
