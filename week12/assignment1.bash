#! /bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst(){

echo -n "Please Input an Instructor Full Name: "
read instName

echo ""
echo "Courses of $instName :"
cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | \
sed 's/;/ | /g'
echo ""

}

function courseCountofInsts(){

echo ""
echo "Course-Instructor Distribution"
cat "$courseFile" | cut -d';' -f7 | \
grep -v "/" | grep -v "\.\.\." | \
sort -n | uniq -c | sort -n -r 
echo ""

}

function displayCoursesOfClassroom(){
  echo -n "Please input a classroom number: "
  read classroom
  echo ""
  echo "Courses in classroom $classroom :"
  xmlstarlet sel -t -m "//tr[td[5]='$classroom']" -v "concat(td[1], ' - ', td[2])" -n courses.txt
  echo ""
}

function displayCourseSubject(){
  echo -n "Please input a subject code: "
  read subject
  echo ""
  echo "Available courses for subject $subject :"
  xmlstarlet sel -t -m "//tr[td[1]='$subject']" -v "concat(td[1], ' ', td[2])" -n courses.txt
  echo ""
}

# TODO - 1
# Make a function that displays all the courses in given location
# function dislaplays course code, course name, course days, time, instructor
# Add function to the menu
# Example input: JOYC 310
# Example output: See the screenshots in canvas

function displayCourseDetails(){
  echo -n "Please input a course code (e.g. JOYC 310): "
  read courseCode
  echo ""
  echo "Course details for $courseCode :"
  xmlstarlet sel -t -m "//tr[contains(td[1], '$courseCode')]" \
    -o "Course Code: " -v "td[1]" -n \
    -o "Course Name: " -v "td[2]" -n \
    -o "Class Days: " -v "td[3]" -n \
    -o "Class Time: " -v "td[4]" -n \
    -o "Instructor: " -v "td[7]" -n courses.txt
  echo ""
}

# TODO - 2
# Make a function that displays all the courses that has availability
# (seat number will be more than 0) for the given course code
# Add function to the menu
# Example input: SEC
# Example output: See the screenshots in canvas

function displayAvailableCourses(){
  echo "Please input class days and time (e.g. MWF 1:45PM): "
  read dayTime
  echo ""
  echo "Available courses for $dayTime :"
  xmlstarlet sel -t -m "//tr[td[3]='${dayTime% *}' and td[4]='${dayTime#* }' and td[6]>0]" \
    -v "concat(td[1], ' ', td[2])" -n courses.txt
  echo ""
}

while :
do
  echo "Please select and option:"
  echo "[1] Display courses of an instructor"
  echo "[2] Display course count of instructors"
  echo "[3] Display courses of a classroom"
  echo "[4] Display available courses of subject"
  echo "[5] Display course details for a course code"
  echo "[6] Display available courses for given days and time"
  echo "[7] Exit"
  read userInput
  echo ""

  if [[ "$userInput" == "5" ]]; then
    displayCourseDetails
  elif [[ "$userInput" == "6" ]]; then
    displayAvailableCourses  
  elif [[ "$userInput" == "1" ]]; then
    displayCoursesOfInst
  elif [[ "$userInput" == "2" ]]; then
    courseCountOfInsts
  elif [[ "$userInput" == "3" ]]; then
    displayCoursesOfClassroom
  elif [[ "$userInput" == "4" ]]; then
    displayCoursesOfSubject
  elif [[ "$userInput" == "7" ]]; then
    exit
    break
  else
    echo "Invalid option" # TODO - 3 Display a message, if an invalid input is given
  fi
done
