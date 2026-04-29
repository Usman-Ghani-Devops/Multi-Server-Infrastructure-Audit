# Multi-Server Infrastructure Audit Script

A lightweight and practical Bash-based solution to audit multiple Linux servers remotely. This script connects via SSH and collects essential system metrics commonly used in real-world infrastructure monitoring and audits.

---

## Overview

In real production environments, system administrators and DevOps engineers frequently need to inspect multiple servers for health, performance, and security checks.

This script automates that process by gathering key system information from multiple servers in a clean and readable format.

---

## Features

* Collects **hostname** of each server
* Displays **uptime** (human-readable format)
* Shows **CPU load averages**
* Reports **memory usage** (used vs total)
* Displays **disk usage** for root partition
* Lists **running services** (top entries)
* Shows **open ports** (active listening sockets)

---

##  Technologies Used

* Bash scripting
* SSH (remote execution)
* Linux system utilities:

  * `hostname`
  * `uptime`
  * `free`
  * `df`
  * `systemctl`
  * `ss`

---

##  Script

```bash
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
```

---

## How to Use

1. Clone the repository

   ```bash
   git clone https://github.com/your-username/multi-server-audit.git
   cd multi-server-audit
   ```

2. Make the script executable

   ```bash
   chmod +x audit.sh
   ```

3. Update server list

   ```bash
   servers=("192.168.1.10" "192.168.1.11" "user@remote-server")
   ```

4. Run the script

   ```bash
   ./audit.sh
   ```

---

## Requirements

* SSH access to all target servers
* SSH key-based authentication (recommended)
* Linux-based systems with `systemctl` support

---

## Sample Output

```
========================================
Server: server1
Hostname: web-01
Uptime: 2 days, 3 hours
CPU Load: 0.15, 0.10, 0.05

Memory Usage:
Used: 1.2G / Total: 4.0G

Disk Usage:
Used: 10G / Total: 40G (25% used)

Running Services:
ssh.service
cron.service
network.service

Open Ports:
tcp LISTEN 0 128 0.0.0.0:22
tcp LISTEN 0 128 0.0.0.0:80
```

---

## Improvements (Future Work)

* Export results to CSV/JSON
* Add parallel execution for faster audits
* Include alerting (email/Slack)
* Full service and port listing (without truncation)
* Integration with monitoring tools

---

## License

This project is open-source and available under the MIT License.

---

##  Author

Usman Ghani

---

## Contribution

Contributions, issues, and feature requests are welcome!
Feel free to fork this repo and submit a pull request.
