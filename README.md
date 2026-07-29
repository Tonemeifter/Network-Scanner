# Project Title
**Network-Scanner** _(netscan.sh)_

# Description
A Bash script that uses Nmap to scan a target host or network for open ports and known vulnerabilities, generating a formatted summary report.

# Purpose/Learning
This is a project for my bash scripting class at University of Advancing Technology focusing on network and device security, shell scripting, and best programming practices.

# Features
* Scans a user-specified target (IP or hostname).
* Detects open ports and running services.
* Identifies potential vulnerabilities using Nmap Scripting Engine (NSE).
* Generates a well-formatted text or HTML report.
* Includes robust error handling and input validation.

# Prerequisites
* Bash (version 4.0 or higher)
* nmap (version 7.80 or higher)
* xmlstarlet (version 1.6.1 or higher)

# Usage
1.  Clone the repository: `git clone git@github.com:YourUsername/my_scanner.git`
2.  Navigate to the directory: `cd my_scanner`
3.  Make the script executable: `chmod +x network_scanner.sh`
4.  Run the script with a target:
_./nestcan.sh <target_IP_or_hostname>_
    
    Example: `./netscan.sh 192.168.1.1`

# Current Status
Initial setup and basic port scanning functionality implemented.

# Future Goals
Will be expanded to include vulnerability identification and detailed reporting.

# Ethical Considerations
This script is intended for educational purposes and for use on networks where you have explicit authorization. Unauthorized scanning of networks is illegal and unethical. The author is not responsible for any misuse of this tool.

# Author
**Richie Cardiel** _(rich.cardiel@gmail.com)_
[Visit GitHub](https://github.com/Tonemeifter/Network-Scanner)
