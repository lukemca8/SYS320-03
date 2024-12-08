\#! /bin/bash



logFile="/var/log/apache2/access.log"



function displayAllLogs(){

	cat "$logFile"

}



function displayOnlyIPs(){

        cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c

}

function displayOnlyPages(){
      cat "$logFile" | awk '{print $7}' | sort | uniq -c | sort -rn
}



function histogram(){

    local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '[' | sort | uniq)



    echo "$visitsPerDay" | while read -r line;
    do

        local withoutHours=$(echo "$line" | cut -d ":" -f 2 | cut -d ":" -f 1)

        local IP=$(echo "$line" | cut -d " " -f 1)

        local newLine="$IP $withoutHours"

        echo "$IP $withoutHours" >> newtemp.txt

    done



    cat "newtemp.txt" | sort -n | uniq -c

    rm newtemp.txt

}
function frequentVisitors() {

    echo "Frequent Visitors:"

    awk '

    {

        split($4, datetime, "[/:]")

        date = substr(datetime[1], 2) "/" datetime[2] "/" substr(datetime[3], 1, 4)

        ip = $1

        visits[ip " " date]++

    }

    END {

        for (key in visits) {

            if (visits[key] > 10) {

                split(key, parts, " ")

                printf "%d %s %s\n", visits[key], parts[1], parts[2]

            }

        }

    }

    ' "$logFile" | sort -rn | head -n 1

}

function suspiciousVisitors() {

  # Place indicators from ioc.txt into an array

  mapfile -t indicators < ioc.txt



  # Create an associative array to store the count of each IP address

  declare -A ip_count



  # Read the log file line by line

  while IFS= read -r line; do

    # Extract the IP address from the line

    ip=$(echo "$line" | awk '{print $1}')



    # Check if the line contains any of the attack indicators

    for indicator in "${indicators[@]}"; do

      if [[ "$line" == *"$indicator"* ]]; then

        # Increment the count for the IP address

        ((ip_count["$ip"]++))

        break

      fi

    done

  done < access.txt



  # Display the unique count of IP addresses

  echo "Unique count of IP addresses associated with suspicious activities:"

  for ip in "${!ip_count[@]}"; do

    echo "$ip: ${ip_count[$ip]}"

  done

}


while :

do

	echo "PLease select an option:"

	echo "[1] Display all Logs"

	echo "[2] Display only IPS"

	echo "[3] Display only Pages"

	echo "[4] Histogram"

	echo "[5] Frequent visitors"

	echo "[6] Suspicious visitors"

	echo "[7] Quit"



	read userInput

	echo ""



	if [[ "$userInput" == "7" ]]; then

		echo "Goodbye"

		break



	elif [[ "$userInput" == "1" ]]; then

		echo "Displaying all logs:"

		displayAllLogs



	elif [[ "$userInput" == "2" ]]; then

		echo "Displaying only IPS:"

		displayOnlyIPs



	elif [[ "$userInput" == "3" ]]; then

                echo "Displaying only Pages:"

                displayOnlyPages



	elif [[ "$userInput" == "4" ]]; then

		echo "Histogram:"

		histogram

        elif [[ "$userInput" == "5" ]]; then

                echo "Displaying frequent visitors:"
                frequentVisitors


	elif [[ "$userInput" == "6" ]]; then

               echo "Displaying suspicious visitors:"

               suspiciousVisitors

	else
          echo "invalid input is given"

	fi

done
