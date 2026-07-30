#! /bin/bash

# Assignment 3.2 Final Project Prep: Format Output (Codio Module: Final Project)

echo "--- Network Security Scan Report ---"
echo "Target IP Address: 127.0.0.1"
echo "Hostname: example.com"

echo
sleep 0.5
echo "--- Open Ports and Detected Services ---"
echo "Port 22/tcp - SSH"
echo "Port 80/tcp - HTTP"
echo "Port 443/tcp - HTTPS"

echo
sleep 0.5
echo "--- Potential Vulnerabilities Identified ---"
echo "CVE-2021-44228 - Log4Shell"
echo "CVE-2017-0144 - EternalBlue"
echo "CVE-2020-0601 - CurveBall"

echo
sleep 0.5
echo "--- Reccomendations for Remediation ---"
echo "Update all softeare to the latest versions."
echo "Change default credentials immediatley."
echo "Implement a firewall."

echo 
sleep 0.5
echo "--- End of Report ---"
echo "$(date)"
