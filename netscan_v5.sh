#! /bin/bash


# =================================================================
# Assignment:   7.2
#
#
# Description:  This script is a network scanner.
#               
#
# Usage:        ./report.sh <target_IP_address>
#               Example: ./report.sh 192.168.1.1
#
# Author:       Richard Cardiel (rcardiel91144@uat.edu)
# Version:      5.0
# Date:         08/14/2026
# =================================================================

# Exit immediately on errors, unset variabales, and set pipefail
set -euo pipefail


# --- Configuration Loading ---
# Find the directory where the script itself is located.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_FILE="${SCRIPT_DIR}/scanner.conf"

# Check if the config file exists before trying to source it.
if [ -f "${CONFIG_FILE}" ]; then
    source "${CONFIG_FILE}"
else
    echo "Error: Configuration file not found at ${CONFIG_FILE}" >&2
    exit 1
fi

FULL_REPORT_DIR="${SCRIPT_DIR}/${REPORT_DIR}"
mkdir -p "${FULL_REPORT_DIR}"

# Ensure there is a single argument in command, otherwise use DEFAULT_TARGET form .conf
if [ $# -eq "1" ]; then
    TARGET="$1"
else
    TARGET="${DEFAULT_TARGET}"
fi

# Output formatting
TIMESTAMP=$(date +%Y.%m.%d_%H:%M:%S)
REPORT_FILE="${FULL_REPORT_DIR}/scan_${TARGET}_${TIMESTAMP}.txt"

# Check if nmap is installed
if ! command -v nmap &> /dev/null; then
    echo "Error: nmap is not installed. Please install it to run this script." >&2
    echo "Try: 'sudo apt install nmap' or 'sudo brew install nmap'"
    exit 1
fi


# --- Functions ---

write_header() {
    echo "--- Network Security Scan Report ---"
    echo "Target IP Address: "$TARGET""
}

write_ports_section() {
    echo "--- Open Ports and Detected Services ---"
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
