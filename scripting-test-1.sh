# #! /bin/bash

# # search for the line containing "Name:"
# line=$(grep "Name:" myfile.txt)

# # extract the second field of that line
# name=$(echo "$line" | cut -d' ' -f2)

# echo "Proud winner of the peanut butter jelly sandwich is: $name"

my_var="joe"
sed "s/bob/$my_var/g" testfile.txt > testfile2.txt
cat testfile2.txt