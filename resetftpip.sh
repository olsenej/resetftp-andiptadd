#!/bin/bash
#grep for an FTP account, if its there, change the password
#grep for an IP, if it's not there, run iptadd

read -p "FTP user to search for: " ftpuser
 if [[ -z  "${ftpuser}" ]]; then
  echo "No user supplied. Quitting."
  exit
 fi
read -p "New password for it: " ftppass
 if [[ -z  "${ftppass}" ]]; then
  echo "No password supplied. Quitting."
  exit
 fi
read -p "List of IPs to search (default is /root/ftpips): " iptips
 if [[ -z  "${iptips}" ]]; then
  echo "No IPs supplied. Quitting."
  exit
 fi

grep $ftpuser /etc/proftpd.db
if [ $? -eq 0 ]; then
 echo "Found it"
 echo $ftppass |ftpasswd --change-password --name=$ftpuser --stdin
else
 echo "Not found. Skipping FTP password reset"
fi

for i in $(cat /root/ftpips);do
 grep $i /etc/sysconfig/iptables
 if [ $? -ne 0 ]; then
  iptadd $i 20:22 "Tk 102211"
 else
  echo "$i already there."
 fi
done
