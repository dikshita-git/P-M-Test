#! /usr/bin/env bash

exec >log.out 2>&1   #Display all the results of the scripts below in a log.out file

 
Diskspace=$(df --total)    #Display disk space
echo -e "The disk space in system is: $Diskspace"

#ps -ef             #List processes

Uptime=$(uptime)    #Display uptime and load average of system
echo "The system uptime and its load average is: $Uptime"


Connection=$(ss -s)               #Listing active connections to system 
echo "Active connections to the system are: $Connection"

Temp=$(sensors)             #Listing the temperature of the system
echo "Temperature of the system is: $Temp"


IP_address=$(ip a)      #Showing IP address of system including network interfaces and IPV4 on the system
echo "IP address and network interface of system: $IP_address"


Hostname=$(hostnamectl)         #Displaying hostname of system
echo "The hostname is: $Hostname"


0 22 * * * /home/dikshita/Desktop/P-M-Test/test.sh
