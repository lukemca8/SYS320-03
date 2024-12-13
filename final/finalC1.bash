#!/bin/bash

indicators=(
  "etc/passwd"
  "cmd="
  "/bin/bash"
  "/bin/sh"
  "1=1#"
  "1=1--"
)

output_file="IOC.txt"

# Create IOC.txt if it doesn't exist
touch "$output_file"

# Fetch the web page content and extract the first <td> from each <tr>
patterns=$(curl -s "http://10.0.17.6/IOC.html" | xmlstarlet sel -t -v '//tr/td[1]' 2>/dev/null)

echo "Extracted patterns:"
echo "$patterns"

while read -r pattern; do
  for indicator in "${indicators[@]}"; do
    if [[ "$pattern" == "$indicator" ]]; then
      echo "$pattern" >> "$output_file"
    fi
  done
done <<< "$patterns"

echo "Matching patterns saved to $output_file"
