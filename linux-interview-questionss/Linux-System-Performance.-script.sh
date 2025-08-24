#!/bin/bash
# System Performance Monitoring Script

echo "==============================="
echo "   System Performance Report"
echo "==============================="

# Host & Date
echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo "Uptime   : $(uptime -p)"
echo "--------------------------------"

# CPU Usage
echo ">>> CPU Usage:"
mpstat 1 1 | awk '/Average:/ {print "User: "$3"%  System: "$5"%  Idle: "$12"%"}'
echo "--------------------------------"

# Memory Usage
echo ">>> Memory Usage:"
free -h | awk 'NR==2{printf "Total: %s | Used: %s | Free: %s | Usage: %.2f%%\n", $2,$3,$4, $3*100/$2 }'
echo "--------------------------------"

# Disk Usage
echo ">>> Disk Usage:"
df -h --total | grep total | awk '{print "Total: "$2" | Used: "$3" | Free: "$4" | Usage: "$5}'
echo "--------------------------------"

# Top 5 processes by CPU & Memory
echo ">>> Top 5 Processes by CPU:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo "--------------------------------"
echo ">>> Top 5 Processes by Memory:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo "--------------------------------"

# Network Statistics
echo ">>> Network Statistics:"
if command -v ifstat >/dev/null 2>&1; then
    ifstat 1 1
else
    echo "Install 'ifstat' for detailed network stats (sudo apt install ifstat)."
    netstat -i
fi
echo "--------------------------------"

# Load Average
echo ">>> Load Average (1, 5, 15 min):"
uptime | awk -F'load average:' '{print $2}'
echo "--------------------------------"

echo "System Performance Report Completed."
