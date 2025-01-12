#!/bin/bash

# Apache2's log directory
LOG_DIR="/var/log/apache2"

# Current time & 10 minutes before
CURRENT_TIME=$(date +"%d/%b/%Y:%H:%M:%S")
START_TIME=$(date -d "10 minutes ago" +"%d/%b/%Y:%H:%M:%S")

# Filter the log to search for 500 response code in the last 10 minutes
ERROR_COUNT=$(grep -h " 500 " $LOG_DIR/*.log |
awk -v start="$START_TIME" -v end="$CURRENT_TIME" 'BEGIN {count=0} {
    if ($4 > "["start && $4 <= "["end) {
        count++
    }
} END {print count}')

# Result Output
if [[ $ERROR_COUNT -gt 0 ]]; then
    echo "There are $ERROR_COUNT of 500 response in the last 10 minutes."
else
    echo "No 500 response in the last 10 minutes."
fi
