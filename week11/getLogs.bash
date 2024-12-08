#! /bin/bash

logDir="/var/log/apache2/"

#getting files in directory
alllogs=$(ls "${logDir}" | grep "access.log" | grep -v "other_vhosts" | grep -v "gz")
echo "${alllogs}"


#Put nothing in access.txt to empty it, or create it
:> access.txt

#here "${alllogs}" does not work. Needs to be a list, not string.
for i in ${alllogs} 
do
     cat "${logDir}${i}" >> access.txt
done

tail access.txt
