# Documentation of "Task: Create a script to automate system maintenance tasks"


#### 1. Create a vagrantfile to run a Ubuntu 20.04.

Here is the vagrantfile in which the base operating system is configured to run Ubuntu 20.04: <code><a href="https://github.com/dikshita-git/P-M-Test/blob/main/Vagrant/Vagrantfile">Vagrant file</a></code>

```
config.vm.box = "generic/ubuntu2004"
```
The config.vm.box would mean to configure the basic unit of vagrant setup called "vagrantbox" which is a complete cloned of the operating system image. In this case it is ubuntu 20.04.




## Your task is to create a bash script that automates the following tasks:

Here is the <code><a href="https://github.com/dikshita-git/P-M-Test/blob/main/test.sh">bash script</a></code> with the codes and below is an explanation of the same. Further the logs of code executions are tracked in <code><a href="https://github.com/dikshita-git/P-M-Test/blob/main/log.out">logfile</a></code>


#### 2. Check the free disk space of the system

```
Diskspace=$(df --total)    #Display disk space
echo -e "The disk space in system is: $Diskspace"
```
This command means display free+used disk space in the linux system.With the flag --total, it displays name of filesystem, free, used etc. 


#### 3. Check the system's uptime and load average

In general:

***Uptime***: It is used to show for how long the system is up followed by the number of active users

***Load average***: Depicts average load on a CPU of the system.


```
Uptime=$(uptime)    #Display uptime and load average of system
echo "The system uptime and its load average is: $Uptime"
```
By using the "uptime" command, we see (from left to right):

The system is up for 20:07:20 up  1:25 and for 1 user with the load averages:
- 0,02: It is the average load on the CPU of system for the last minute.
- 0,15: It is the average load on the CPU of system for the last 5-minutes interval time.
- 0,43: It is the 15-minutes average load on the CPU of system.

These help us to understand how the undergoing processes are using the CPU over the time.


#### 4. Check the number of active connections to the system

```
Connection=$(ss -l)               #Listing all listening connections to system 
echo "Active connections to the system are: $Connection"
```
The "show socket" or ss command displays the active TCP, UDP, RAW, INET, FRAG etc. connections or sockets on the linux system. It is an alternative to netstat. It shows mainly 4 parts:

- ***Established:*** Number of connections established.
- ***Closed:*** Connection which were ended or closed.
- ***Orphaned:*** Means socket no longer is attached to any socket descriptor in any of teh user's process. 
- ***Timewait:*** Keeps the sockets open for 60 seconds as buffer time in linux after the application has shutdown the sockets in order to ensure all the data has been transmitted between client and server.


#### 5. Check the system's temperature

```
Temp=$(sensors)             #Listing the temperature of the system
echo "Temperature of the system is: $Temp"

```

It lists the system's CPU tempertaure:

- ***dell_smm-isa-0000:*** CPU fan, which is managed by the system firmware.
- ***acpitz-acpi-0:*** Temperature sensor near/on the CPU socket.
- ***coretemp-isa-0000:***  Temperature of the specific cores.


#### 6. Check the system's IP address

```
IP_address=$(ip a)      #Showing IP address of system including network interfaces and IPV4 on the system
echo "IP address and network interface of system: $IP_address"

```

#### 7. Check the system's hostname

```
Hostname=$(hostnamectl)         #Displaying hostname of system
echo "The hostname is: $Hostname"

```
