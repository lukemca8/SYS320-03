#!/bin/bash

# Get the log file and IOC file from command-line arguments
log_file="$1"
ioc_file="$2"

# Output file name
output_file="report.txt"

# Create or overwrite the output file
echo "IP, Date/Time, Page" > "$output_file"

# Read the indicators of compromise from the IOC file
indicators=($(grep -v '^#' "$ioc_file"))

# Loop through each line in the log file
while read -r line; do
    # Extract the IP address, date/time, and page accessed from the log line
    ip=$(echo "$line" | awk '{print $1}')
    datetime=$(echo "$line" | awk '{print $4 " " $5}' | sed 's/\[//;s/\]//')
    page=$(echo "$line" | awk '{print $7}')

    # Check if the line contains any indicators of compromise
    for indicator in "${indicators[@]}"; do
        if grep -q "$indicator" <<< "$line"; then
            # If a match is found, append the IP, date/time, and page to the output file
            echo "$ip, $datetime, $page" >> "$output_file"
            break
        fi
    done
done < "$log_file"

echo "Report saved to $output_file"
