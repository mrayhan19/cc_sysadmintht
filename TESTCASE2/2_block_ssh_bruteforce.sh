#!/bin/bash

###############################################
# 2. Script for block brute force ssh request #
###############################################



# SSH log file location
LOG_FILE="/var/log/auth.log"
# SSH log file location (for CentOS/RHEL)
# LOG_FILE="/var/log/secure"

# Max attempt before blocking (For test I use 3 attempts)
MAX_ATTEMPTS=3

# Block durations in seconds (For test I use 3 minutes)
BLOCK_DURATION=180

# iptables chain for blocking
BLOCK_CHAIN="BLOCK_SSH_BRUTEFORCE"

# Make iptables chain if not exist
iptables -L $BLOCK_CHAIN -n >/dev/null 2>&1 || iptables -N $BLOCK_CHAIN
iptables -I INPUT -j $BLOCK_CHAIN

# Block IP function
block_ip() {
    local ip="$1"
    echo "Blocking IP: $ip"
    iptables -A $BLOCK_CHAIN -s $ip -j DROP
    # Set timer for reopening the blocked IP
    (sleep $BLOCK_DURATION; iptables -D $BLOCK_CHAIN -s $ip -j DROP) &
}

# Get IP list wich does failed attempt
check_brute_force() {
    awk "/Failed password for/ {print \$(NF-3)}" $LOG_FILE | sort | uniq -c | while read count ip; do
        if [ "$count" -ge "$MAX_ATTEMPTS" ]; then
            # Cek if the IP has been blocked
            iptables -L $BLOCK_CHAIN -n | grep -q "$ip"
            if [ $? -ne 0 ]; then
                block_ip "$ip"
            fi
        fi
    done
}

# Main loop to monitor SSH brute force
echo "Monitoring for brute force attempt..."
tail -Fn0 $LOG_FILE | while read line; do
    echo "$line" | grep "Failed password" >/dev/null
    if [ $? -eq 0 ]; then
        check_brute_force
    fi
done
