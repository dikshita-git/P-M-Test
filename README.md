# Step-by-step Documentation


#### 1. Create a vagrantfile to run a Ubuntu 20.04.

Here is the <code><a href="https://github.com/dikshita-git/P-M-Test/blob/main/Vagrant/Vagrantfile">vagrantfile</a></code> in which the base operating system is configured to run Ubuntu 20.04 in the line 15:

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
