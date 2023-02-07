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

