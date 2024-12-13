#!/bin/bash

# Input file name
input_file="report.txt"

# Output HTML file name
output_file="report.html"

# HTML template
html_template='<!DOCTYPE html>
<html>
<head>
  <title>Access Logs with IOC Indicators</title>
  <style>
    table {
      border-collapse: collapse;
      width: 100%;
    }
    th, td {
      padding: 8px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    th {
       background-color: #f2f2f2;
    }
  </style>
</head>
<body>
  <h1>Access Logs with IOC Indicators</h1>
  <table>
    <tr>
      <th>IP</th>
      <th>Date/Time</th>
      <th>Page</th>
    </tr>
    <!-- TABLE_ROWS -->
  </table>
</body>
</html>'

# Generate table rows from the input file
table_rows=""

while IFS=", " read -r ip datetime page; do
  table_rows+="    <tr>
      <td>$ip</td>
      <td>$datetime</td>
      <td>$page</td>
    </tr>
"
done < "$input_file"

# Replace the placeholder with the actual table rows
html_report="${html_template//<!-- TABLE_ROWS -->/$table_rows}"

# Save the HTML report to the output file
echo "$html_report" > "$output_file"

# Move the HTML report to the specified directory
mv "$output_file" "/var/www/html/"

echo "HTML report generated and moved to /var/www/html/$output_file"
