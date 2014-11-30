hipsterpi
=========

A boombox is not a toy

Installation
------------
* sudo apt-get update
* sudo apt-get install puppet git
* git clone https://github.com/mt-inside/hipsterpi.git
* cd hipsterpi
* sudo bash -c 'echo "${PWD}/install.sh" >> /etc/rc.local'
* sudo vi /etc/rc.local and remove the stupid "exit 0"
* sudo reboot

Design
------
This system is "packaged" as a set of puppet modules. These run periodically from boot, ensuring the that scripts are "installed" and the daemons running.

It could equally have been packaged as .DEBs that install the scripts and some init services.
