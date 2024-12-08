file="/var/log/apache2/access.log"

function pageCount(){
    allPages=$(cat "$file" | grep "GET" | cut -d' ' -f7 | sort | uniq -c)
    echo "$allPages"
}

function countingCurlAccess(){
    curlAccess=$(cat "$file" | grep "curl/7.81.0" | cut -d' ' -f1 | sort | uniq -c | sed 's/$/ "curl\/7.81.0"/')
    echo "$curlAccess"
}

pageCount
countingCurlAccess
