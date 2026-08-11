#! /bin/bash


# =================================================================
# Assignment:   5.2
#
#
# Description:  This script is a network scanner.
#               
#
# Usage:        ./report.sh <target_IP_address>
#               Example: ./report.sh 192.168.1.1
#
# Author:       Richard Cardiel (rcardiel91144@uat.edu)
# Version:      3.0
# Date:         08/02/2026
# =================================================================

# Ensure there is a single argument in command, otherwise EXIT
if [ $# -ne "1" ]; then
    echo "Usage: $0 <target_ip_or_hostname>" >&2
    echo "Example: ./"$0" 192.168.1.1" >&2
    exit 1
fi

# Check if nmap is installed
if ! command -v nmap &> /dev/null; then
    echo "Error: nmap is not installed. Please install it to run this script." >&2
    echo "Try: 'sudo apt install nmap' or 'sudo brew install nmap'"
    exit 1
fi

TARGET="$1"

# --- Functions ---

write_header() {
    echo "--- Network Security Scan Report ---"
    echo "Target IP Address: $1"
}

write_ports_section() {
    echo "--- Open Ports and Detected Services ---"
    local TARGET="$1"
    nmap -sV "$TARGET" | grep "open"
}

write_vulns_section() {
    echo "--- Potential Vulnerabilities Identified ---"
    SCAN_RESULTS=$(nmap -sV --script vuln "$TARGET")
    echo "$SCAN_RESULTS" | grep "VULNERABLE"
}

write_recs_section() {
    echo "--- Reccomendations for Remediation ---"
    echo "Update all softeare to the latest versions."
    echo "Change default credentials immediatley."
    echo "Implement a firewall."
}

write_footer() {
    echo "--- End of Report ---"
    echo "$(date)"
}

main() {
    if [ $# -ne "1" ]; then
    echo "Usage: $0 <target_ip_or_hostname>" >&2
    exit 1
    fi

    local TARGET="$1"
    REPORT_FILE="output.txt"
    write_header "$TARGET"> $REPORT_FILE
    echo >> $REPORT_FILE
    write_ports_section "$TARGET" >> $REPORT_FILE
    echo >> $REPORT_FILE
    write_recs_section >> $REPORT_FILE
    echo >> $REPORT_FILE
    write_footer >> $REPORT_FILE
}

# --- Main Script Logic ---

main "$@"
exit 0
