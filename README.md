# Documentation of the task to create a script to automate system maintenance tasks


#### 1. Create a vagrantfile to run an Ubuntu 20.04 VM.

Here is the vagrantfile in which the base operating system is configured to run Ubuntu 20.04: <code><a href="https://github.com/dikshita-git/P-M-Test/blob/main/Vagrantfile">Vagrant file</a></code>

The most importan part is the definition of the box, which is used as base image:
```
config.vm.box = "generic/ubuntu2004"
```
The config.vm.box would mean to configure the basic unit of vagrant setup called "vagrantbox" which is a complete cloned of the operating system image. In this case it is ubuntu 20.04.

Once it is setup, the follwoing commands are run to start the machine using vagrant and all the following commands were executed thereafter:

```
vagrant up
vagrant ssh
```


## Your task is to create a bash script that automates the following tasks:

Here is the <code><a href="https://github.com/dikshita-git/P-M-Test/blob/main/test.sh">bash script</a></code> with the codes and below is an explanation of the same. Further the logs of code executions are tracked in <code><a href="https://github.com/dikshita-git/P-M-Test/blob/main/log.out">logfile</a></code>
The logfile name is log.out and is compressed and rotated for 3 times.

A statefile is also present which will show us the last time the bash script was run.



#### 2. Check the free disk space of the system

```
echo "# The disk space in system is: "
df --total #Display disk space
```
This command means display free+used disk space in the linux system.With the flag --total, it displays name of filesystem, free, used etc. 


#### 3. Check the number of active connections to the system

```
echo "# The number of active connections to the system are:"
ss -s       #Listing active connections to system 
```

The "show socket" or ss command displays the active TCP, UDP, RAW, INET, FRAG etc. connections or sockets on the linux system. It is an alternative to netstat. It shows mainly 4 parts:

- ***Established:*** Number of connections established.
- ***Closed:*** Connection which were ended or closed.
- ***Orphaned:*** Means socket no longer is attached to any socket descriptor in any of teh user's process. 
- ***Timewait:*** Keeps the sockets open for 60 seconds as buffer time in linux after the application has shutdown the sockets in order to ensure all the data has been transmitted between client and server.



#### 4. Check the number of running processes

```
echo "# Check the number of running processes"
ps -ef --no-headers | wc -l
```
It lists the running processes and since its a huge output so for convenience with no headers and making a word count to help us see the number oflines.


#### 5. Check the system's uptime and load average

In general:

***Uptime***: It is used to show for how long the system is up followed by the number of active users

***Load average***: Depicts average load on a CPU of the system.


```
echo "# The system uptime and loadavg are:"
uptime     #Display uptime and load average of system
```
By using the "uptime" command, we see (from left to right):

The system is up for 20:07:20 up  1:25 and for 1 user with the load averages:
- 0.00: It is the average load on the CPU of system for the last minute.
- 0.01: It is the average load on the CPU of system for the last 5-minutes interval time.
- 0.00: It is the 15-minutes average load on the CPU of system.

These help us to understand how the undergoing processes are using the CPU over the time.


#### 6. Check the system's memory usage

```
echo "# Check the system's memory usage:"
free -h
```
To display free memory, free command is used. For human ease the flag --h is used to shorten the output to shortest 3 digits with units of memory.


#### 7. Check the system's temperature

```
echo "# Temperature of the system is:"
sensors             #Listing the temperature of the system

```

It lists the system's CPU tempertaure:

- ***dell_smm-isa-0000:*** CPU fan, which is managed by the system firmware.
- ***acpitz-acpi-0:*** Temperature sensor near/on the CPU socket.
- ***coretemp-isa-0000:***  Temperature of the specific cores.


#### 6. Check the system's IP address

```
echo "# IP address and network interface of system:"
ip a       #Showing IP address of system including network interfaces and IPV4 on the systemnetwork interfaces and IPV4 on the system
echo "IP address and network interface of system: $IP_address"

```

#### 7. Check the system's hostname

```
echo "The hostname is: "
hostname         #Displaying hostname of system

```


#### 8. Log should be rotated

lets say logrotate works daily

mext daily execution:
before:
log.out <- 100kbit
log.out.1 <- 1MB
log.out.2 <- 2MB
log.out.3  <- 3MB

after:
log.out <- 0
log.out.1 <- 100kbit
log.out.2 <- 1MB
log.out.3  <- 2MB
(old 3 is removed)

whole purpose: logs shall not become too big

#### 9. The script should be executed every day at a specific time (e.g. 10pm)

# create systemd timer and service unit
# it is the modern way to configure cron jobs

#create new systemd unit files
#maintenance.service will execute the test.sh script, which is expected to exist in /home/vagrant
#the timer unit will execute the maintenance.service unit
cat  <<EOF >maintenance.service
[Unit]
Description=Do system maintenance tasks

[Service]
Type=oneshot
WorkingDirectory=/home/vagrant
ExecStart=/bin/bash /home/vagrant/test.sh
EOF

cat  <<EOF >maintenance.timer
[Unit]
Description=timer for system maintenance tasks

[Timer]
OnCalendar=*-*-* 22:00:00
Persistent=true
Unit=maintenance.service

[Install]
WantedBy=timers.target
EOF

# copy the new unit files to the appropriate location so that systemd can find them
sudo cp maintenance.timer maintenance.service /etc/systemd/system
  
#load the new unit files into systemd
```
systemctl daemon-reload
```
#start the timer on boot

```
systemctl enable maintenance.timer
```

#start the timer now

```
systemctl start maintenance.timer
```

