# Rotate log if it exists
# logrotate is assumed to be installed on the system
# lograte rotates logs so they do not become too big
# only a specific amount of rotated files is kept
# will print an error on first execution due to the missing log.out

LOGFILE=log.out

cat  <<EOF >log.conf
"$LOGFILE" {
    rotate 3
    compress
}
EOF

logrotate -s statefile -f log.conf

# Print all the results of the scripts below in a log.out file
exec >log.out 2>&1   
 
echo "# The disk space in system is: "
df --total #Display disk space

echo "# The number of active connections to the system are:"
ss -s       #Listing active connections to system 

echo "# Check the number of running processes"
ps -ef --no-headers | wc -l

echo "# The system uptime and loadavg are:"
uptime     #Display uptime and load average of system

echo "# Check the system's memory usage:"
free -h

echo "# Temperature of the system is:"
sensors             #Listing the temperature of the system

echo "# IP address and network interface of system:"
ip a #Showing IP address of system including network interfaces and IPV4 on the system

echo "The hostname is: "
hostname         #Displaying hostname of system




# because it is more modern
#0 22 * * * /home/dikshita/Desktop/P-M-Test/test.sh
