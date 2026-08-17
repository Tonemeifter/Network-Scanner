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
    echo "Try: 'sudo apt install nmap' or 'brew install nmap'" >&2
    exit 2
fi


# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it to run this script." >&2
    echo "Try: 'sudo apt install jq' or 'brew install jq'" >&2
    exit 3
fi

run_network_scan() {
    echo "Scanning target $TARGET..." >&2
    SCAN_RESULTS=$(nmap $NMAP_FLAGS -sV --script vuln "$TARGET")
}

write_header() {
    echo "--- Network Security Scan Report ---"
    
    echo "Target IP Address: "$TARGET""
}

write_ports_section() {
    echo "--- Open Ports and Detected Services ---"
    
    echo "Scanning for open ports..." >&1
    echo "$SCAN_RESULTS" | grep "open" || echo "No open ports found."
}

write_vulns_section() {
    echo "--- Potential Vulnerabilities Identified ---"
    
    echo "Scanning for potential vulnerabilities" >&1
    echo "$SCAN_RESULTS" | grep -A 2 "VULNERABLE" || echo "No vulnerable services flagged."

    echo "--- Analyzing Service Versions ---"

    # Process the full scan results line by line
    echo "$SCAN_RESULTS" | while read -r line; do
    
      # Check for specific vulnerable versions
      case "$line" in
        *"vsftpd 2.3.4"*)
            echo "[!!] VULNERABILITY DETECTED: vsftpd 2.3.4 is running, which contains a known critical backdoor (CVE-2011-2523)."
          ;;
        *"Apache httpd 2.4.49"*)
          echo "[!!] VULNERABILITY DETECTED: Apache 2.4.49 is running, which is vulnerable to path traversal (CVE-2021-41773)."
          ;;
        *"Samba 3.0.20"*)
          echo "[!!] VULNERABILITY DETECTED: Samba 3.0.20 is running, which is vulnerable to remote command execution (CVE-2007-2447)."
          ;;
        *"ProFTPD 1.3.5"*)
          echo "[!!] VULNERABILITY DETECTED: ProFTPD 1.3.5 is running, which allows unauthenticated file read/write via mod_copy (CVE-2015-3306)."
          ;;
      esac
done
}

write_recs_section() {
    echo "--- Reccomendations for Remediation ---"
    
    # Extract open ports and service names from Nmap
    echo "$SCAN_RESULTS" | grep "open" | while read -r line; do
        PORT=$(echo "$line" | awk '{print $1}')
        SERVICE=$(echo "$line" | awk '{print $3}')
        
        case "$SERVICE" in
            ssh)
                echo "[+] SSH ($PORT): Enforce public key authentication and update sshd_config."
                ;;
            http|https)
                echo "[+] Web Service ($PORT): Ensure TLS 1.3 is enforced and update web server headers."
                ;;
            *)
                # Optional: Trigger NVD API query here, or fall back to general guidance
                echo "[+] $SERVICE ($PORT): Audit service configurations and apply latest patches."
                ;;
        esac
    done
}

write_recs_section_alt() {
    echo "--- Reccomendations for Remediation ---"
   
    # Grabs first 3 unique CVE IDs identified by Nmap
    # true to prevent set -euo pipefail from crashing the script when grep finds no matches
    CVES=$(echo "$SCAN_RESULTS" | grep -oE "CVE-[0-9]{4}-[0-9]+" | sort -u | head -n 3 || true)

    if [ -z "$CVES" ]; then
        echo "No specific CVE vulnerabilities detected."
        echo "General Guidance: Enforce sctrict access controls and keep services up to date."
    else
        for cve in $CVES; do
            echo "Querying NVD API for $cve..." >&1

            # Fetch JSON payload from NVD
            RESPONSE=$(curl -s "https://services.nvd.nist.gov/rest/json/cves/2.0?cveId=$cve")
            # Parse English description and CVSS V3.1 Base Score using jq
            DESC=$(echo "$RESPONSE" | jq -r '([.vulnerabilities[0].cve.descriptions[]? | select(.lang=="en").value][0]) // "No description available."' 2>/dev/null)
            SCORE=$(echo "$RESPONSE" | jq -r '(.vulnerabilities[0].cve.metrics.cvssMetricV31[0].cvssData.baseScore) // "N/A"' 2>/dev/null)
            SEVERITY=$(echo "$RESPONSE" | jq -r '(.vulnerabilities[0].cve.metrics.cvssMetricV31[0].cvssData.baseSeverity) // "UNKNOWN"' 2>/dev/null)

            echo "  [$cve] Severity: $SEVERITY (CVSS: $SCORE)"
            echo "  Summary: $DESC"
            echo "--------------------------------------------------"
            
            sleep 6 # Sleep to respect NVD's rate limit window
        done
    fi
}

write_footer() {
    echo "--- End of Report ---"
    
    echo "$(date)"
    echo "Scan complete." >&1
}

main() {
    run_network_scan

    write_header "$TARGET"> "$REPORT_FILE"
    echo >> "$REPORT_FILE"
    write_ports_section "$TARGET" >> "$REPORT_FILE"
    echo >> "$REPORT_FILE"
    write_vulns_section "$TARGET" >> "$REPORT_FILE"
    echo >> "$REPORT_FILE"
    write_recs_section_alt >> "$REPORT_FILE"
    echo >> "$REPORT_FILE"
    write_footer >> "$REPORT_FILE"
}

# --- Main Script Logic ---

main "$@"
exit 0
