file="/var/log/apache2/access.log"

cat "$file" | grep "GET /page2.html" | cut -d ' ' -f1,7 | trim
