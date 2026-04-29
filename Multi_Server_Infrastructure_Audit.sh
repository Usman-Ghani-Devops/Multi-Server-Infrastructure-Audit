#!/bin/bash

# List of servers
servers=("server1" "server2" "server3")

for server in "${servers[@]}"
do
    echo "========================================"
    echo "Server: $server"

    ssh "$server" '
        echo "Hostname: $(hostname)"
        echo "Uptime: $(uptime -p | cut -d " " -f2-)"
        echo "CPU Load: $(uptime | awk -F "load average:" "{print $2}")"
        
        echo "Memory Usage:"
        free -h | awk '\''NR==2{print "Used: "$3" / Total: "$2}'\''
        
        echo "Disk Usage:"
        df -h / | awk '\''NR==2{print "Used: "$3" / Total: "$2" ("$5" used)"}'\''
        
        echo "Running Services:"
        systemctl list-units --type=service --state=running | head -5
        
        echo "Open Ports:"
        ss -tuln | head -5
    '

    echo ""
done
