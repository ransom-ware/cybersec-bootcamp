#!/bin/bash

#Variables
output=~/research/sys_info.txt
ip=$(ip addr | grep inet | tail -2 | head -1)
paths=(
/etc/passwd
/etc/shadow
)

#File and directory setup
if [ ! -d ~/research ]
then
  mkdir ~/research
fi

if [ -f $output ]
then
  rm $output
fi

#Commands
echo -e "\nThe permissions for sensitive /etc files: \n" >> $output
for file in ${paths[@]}
do
  ls -l $file >> $output
done
echo -e "\nCPU Info:\n" >> $output
lscpu | grep CPU >> $output
echo -e "\nDisk Info:\n" >> $output
df -H | head -2 >> $output
echo -e "\nWho is logged in:\n $(who -a) \n" >> $output
echo "Brief System Audit" >> $output
date >> $output
echo "" >> $output
echo "Machine Type Info:" >> $output
echo $MACHTYPE >> $output
echo "User: $USER" >> $output
echo "Hostname: $(hostname -s) " >> $output
echo "Host IP: $ip " >> $output
echo -e "\nList of 777 Files:" >> $output
find / -type f -perm 777 >> $output
echo -e "\nTop 10 Processes" >> $output
ps -aux | awk '{print $1, $2, $3, $4, $11}' | head >> $output
echo "------------------------------------------------------------------" >> $output
