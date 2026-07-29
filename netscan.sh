#! /bin/bash


# =================================================================
# Assignment:
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
# Date:         
# =================================================================

# Ensure there is a single argument in command, otherwise EXIT
if [ $# -ne "1" ]; then
    echo "Usage: $0 <target_ip_or_hostname>" >&2
    echo "Example: ./"$0" 192.168.1.1" >&2
    exit 1
fi

# --- Functions ---

write_header() {
    echo "--- Network Security Scan Report ---"
    echo "Target IP Address: $1"
}

write_ports_section() {
    echo "--- Open Ports and Detected Services ---"
    echo "Port 22/tcp - SSH"
    echo "Port 80/tcp - HTTP"
    echo "Port 443/tcp - HTTPS"
}

write_vulns_section() {
    echo "--- Potential Vulnerabilities Identified ---"
    echo "CVE-2021-44228 - Log4Shell"
    echo "CVE-2017-0144 - EternalBlue"
    echo "CVE-2020-0601 - CurveBall"
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

    REPORT_FILE="output.txt"
    write_header "$1" > $REPORT_FILE
    echo >> $REPORT_FILE
    write_ports_section >> $REPORT_FILE
    echo >> $REPORT_FILE
    write_recs_section >> $REPORT_FILE
    echo >> $REPORT_FILE
    write_footer >> $REPORT_FILE
}

# --- Main Script Logic ---

main "$@"
exit 0
