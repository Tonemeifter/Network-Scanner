## Project Title
**Network-Scanner** _(netscan.sh)_

---

## Description
A Bash script that uses Nmap to scan a target host or IP address for open ports and known vulnerabilities, and queries NVD API for CVE inspection, generating a formatted summary report.

---

## Purpose
Developed as a coursework project at the **University of Advancing Technology (UAT)** to demonstrate shell scripting standards, network security fundamentals, API integration, and defensive scripting practices

---

## Features
* **Automated Network Reconnaissance:** Scans target IPs or domain names for active hosts and open TCP/UDP ports.
* **Service & Version Detection:** Inspects running services (`-sV`) and matches identified versions against local signature cases (e.g., `vsftpd 2.3.4`, `Apache 2.4.49`, `Samba 3.0.20`, `ProFTPD 1.3.5`).
* **NSE Vulnerability Integration:** Executes Nmap Scripting Engine (`--script vuln`) to surface known host flaws.
* **Live NVD API Enrichment:** Extracts unique CVE identifiers from scan outputs and queries the NIST NVD v2.0 REST API to fetch CVSS v3.1 scores, severity ratings, and vulnerability summaries.
* **Non-Disruptive Failure Handling:** Validates API payloads and network connection status to prevent script crashes on clean targets or API rate-limit events.
* **Structured File Reporting:** Automatically formats scan findings and appends timestamped `.txt` reports to a configurable destination directory.

---

## Prerequisites
| Dependency | Minimum Version | Purpose |
| :--- | :--- | :--- |
| **Bash** | `4.0+` | Execution environment & string matching |
| **Nmap** | `7.80+` | Network discovery & NSE vulnerability scanning |
| **curl** | `7.7.0+` | HTTPS REST requests to the NIST NVD API |
| **jq** | `1.6+` | Command-line JSON payload parsing 

---

## Usage
1.  Clone the repository: `git clone git@github.com:Tonemeifter/Network-Scanner.git`
2.  Navigate to the directory: `cd Network-Scanner`
3.  Make the script executable: `chmod +x network_scanner.sh`
4.  Run the script with a target:
_./nestcan.sh <target_IP_or_hostname>_
    
    Example: `./netscan.sh 192.168.1.1`

**NOTE:** Running without arguments will target `127.0.0.1` by **DEFAULT**

---

## Current Status
Functional network scanner.

---

## Configuration & Output

* **`scanner.conf`:** Configuration file located in the script directory to define output directory paths (`REPORT_DIR`) and default Nmap scan parameters (`NMAP_FLAGS`).
* **Report Artifacts:** Generated reports are saved in the configured output folder using the following naming convention:

  `reports/scan_<TARGET>_YYYY.MM.DD_HH:MM:SS.txt`

---

## Ethical Considerations
This script is intended for educational purposes and for use on networks where you have explicit authorization. Unauthorized scanning of networks is illegal and unethical. The author is not responsible for any misuse of this tool.

---

## Author
**Richie Cardiel** _(rich.cardiel@gmail.com)_
[Visit GitHub](https://github.com/Tonemeifter/Network-Scanner)
