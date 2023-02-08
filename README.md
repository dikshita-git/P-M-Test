# Documentation of the task to create a script to automate system maintenance tasks

#### 1. Create a Vagrantfile to run an Ubuntu 20.04 VM.

Here is the Vagrantfile in which the base operating system is installed and configured: <code><a href="https://github.com/dikshita-git/P-M-Test/blob/main/Vagrantfile">Vagrant file</a></code>

The most importan part of it is the definition of the box, which is used as base image. In this case it is Ubuntu 20.04 Focal Fossa:
```
config.vm.box = "ubuntu/focal64"
```
Vagrant will take care of basic settings like storage and networking.


#### 2. Start the new vagrant machine and ssh into it

Once it is setup, the follwoing commands can be used to start the machine and connect via ssh:
```
vagrant up
vagrant ssh
```

#### 3. copy the test.sh script into the vm at /home/vagrant
(it is possible to use the shared vagrant folder at /vagrant inside the vm for this purpose)

The bash script containing the desired functionality can be found here: <code><a href="https://github.com/dikshita-git/P-M-Test/blob/main/test.sh">bash script</a></code>

Further the log of one script executions is available at: <code><a href="https://github.com/dikshita-git/P-M-Test/blob/main/log.out">logfile</a></code>

The end of this README.md file contains explanation of the used commands.

#### 4. create systemd timer and service unit at /home/vagrant

- The script should be executed every day at a specific time (e.g. 10pm)
- to achieve this functionality we create a systemd timer and service unit
- it is the modern way to configure cron jobs

##### create new systemd unit files

- maintenance.service will execute the test.sh script, which is expected to exist in /home/vagrant
- the timer unit will execute the maintenance.service unit
```
cat  <<EOF >maintenance.service
[Unit]
Description=Do system maintenance tasks

[Service]
Type=oneshot
WorkingDirectory=/home/vagrant
ExecStart=/bin/bash /home/vagrant/test.sh
EOF
```
```
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
```
Below are the screenshots of the output of timer of vm, log of service unit and log of timer unit respectively:

<img src="https://github.com/dikshita-git/P-M-Test/blob/main/screenshots/timers_of_vm.png">
<p align="center">Timers of VM</p>


<img src="https://github.com/dikshita-git/P-M-Test/blob/main/screenshots/log_og_service_unit.png">
<p align="center">Log of service unit</p>

<img src="https://github.com/dikshita-git/P-M-Test/blob/main/screenshots/log_of_timer_unit.png">
<p align="center">Log of timer unit</p>



#### 5. Move the new unit files to the appropriate location so that systemd can find them

```
sudo mv maintenance.timer maintenance.service /etc/systemd/system
```

#### 6. load the new unit files into systemd


```
sudo systemctl daemon-reload
```

#### 7. Start and enable the timer

- both the service and timer can be started and enabled
- the timer only starts the service
- it is sufficient to start and enable the timer, so that the service is started at 10 pm
- enabling the service would mean starting it on boot

```
sudo systemctl enable maintenance.timer
```

```
sudo systemctl start maintenance.timer
```

##### Show the resulting timer:

```
systemctl list-timers
```

#### 8. testing functionality of the maintenance.service

- Open terminals with the logs of the service and timer unit

```
sudo journalctl -fu maintenance.service
sudo journalctl -fu maintenance.timer
```

- test the service unit

```
sudo systemctl start maintenance.service
```
It will show an error on first execution, which is expected. The log.out can't be rotated if it doesn't yet exist.


------------------------------------------------

### Description of the commands used in the test.sh script


#### Check the free disk space of the system
```
echo "# The disk space in system is: "
df --total #Display disk space
```
This command means display free+used disk space in the linux system. With the flag --total it displays the name of the filesystem, the free and used space, etc. 

#### Check the number of active connections to the system
```
echo "# The number of active connections to the system are:"
ss -s       #Listing active connections to system 
```

The "socket statistics" or ss command displays the active TCP, UDP, RAW, INET, FRAG etc. connections or sockets on the linux system. It is an alternative to netstat. It shows mainly 4 parts:

- ***Established:*** Number of connections established.
- ***Closed:*** Connection which were ended or closed.
- ***Orphaned:*** Means socket no longer is attached to any socket descriptor in any of the user's process. 
- ***Timewait:*** Keeps the sockets open for 60 seconds as buffer time in linux after the application has shutdown the sockets in order to ensure all the data has been transmitted between client and server.

#### Check the number of running processes
```
echo "# Check the number of running processes"
ps -ef --no-headers | wc -l
```
ps lists the running processes. Adding the flag --no-headers removes the header row, which would be added by default otherwise. 
When we count the lines with "wc -l" this way we get the correct number of processes.

#### Check the system's uptime and load average
In general:

***Uptime***: It is the time for how long the system is up.

**Number of active users**: The number of users logged into the system

**Load average**: Depicts average load on a CPU of the system. It is the number of CPUs used by average in time frames of the last 1 minute, 5 minutes and 15 minutes.

All values can be gathered by using the uptime command:
```
echo "# The system uptime and loadavg are:"
uptime     #Display uptime and load average of system
```

By using it, we see (from left to right):
The system is up for 20:07:20 up 1:25
- 1 user is logged in
- The the load averages of the full system:
    - 0.00: It is the average load on the CPU of system for the last minute.
    - 0.01: It is the average load on the CPU of system for the last 5-minutes interval time.
    - 0.00: It is the 15-minutes average load on the CPU of system.

These help us to understand how the undergoing processes are using the CPU over the time.

#### Check the system's memory usage
```
echo "# Check the system's memory usage:"
free -h
```
To display free memory, free command is used. For human readable output the flag --h is used.


#### Check the system's temperature
```
echo "# Temperature of the system is:"
sensors             #Listing the temperature of the system

```

It lists the system's CPU and other tempertaures:

- ***dell_smm-isa-0000:*** CPU fan, which is managed by the system firmware.
- ***acpitz-acpi-0:*** Temperature sensor near/on the CPU socket.
- ***coretemp-isa-0000:***  Temperature of the specific cores.

#### Check the system's IP address
```
echo "# IP address and network interface of system:"
ip a       #Showing IP address of system including network interfaces and IPV4 on the systemnetwork interfaces and IPV4 on the system
echo "IP address and network interface of system: $IP_address"

```

#### Check the system's hostname
```
echo "The hostname is: "
hostname         #Displaying hostname of system

```

#### Logs should be rotated

The logfile name is log.out and is compressed and rotated for 3 times.

A statefile is also created which will show logroate the last time the rotation happened.

A Sample rotation will work as follows:

Next daily execution:

***before:***

   log.out <- 100kbit
   
   log.out.1 <- 1MB
   
   log.out.2 <- 2MB
   
   log.out.3  <- 3MB
   

***after:***

   log.out <- 0
   
   log.out.1 <- 100kbit
   
   log.out.2 <- 1MB
   
   log.out.3  <- 2MB
   
(old 3 is removed)

:bulb: Whole purpose: logs shall not become too big

