# Docker Provisioner

This document describes the steps that the [co8InstallDocker.sh](../scripts/opensource/docker/co8InstallDocker.sh) script performs to install the Docker container runtime.
The script is not used on itself, but through the [co8installDockerAs.sh](../scripts/opensource/docker/co8installDockerAs.sh) script, which is a variant of [runAs.sh](../scripts/opensource/docker/runAs.sh). 

## co8installDockerAs.sh
The [co8installDockerAs.sh](../scripts/opensource/docker/co8installDockerAs.sh) does a few preparations before actually calling the  [co8InstallDocker.sh](../scripts/opensource/docker/co8InstallDocker.sh).
This script will take a set of parameters:

1. *PROD*: This stands for the product for which the provisioner is run. And provided with the _description_ property from the [provisioners.yml](../provisioners.yml). 
This is used to print a line for to recognize the output of the particular provisioner.
2. *SCRIPT_HOME*: Location of the provisioning-script, in this case particularly [co8InstallDocker.sh](../scripts/opensource/docker/co8InstallDocker.sh).
3. *USR*: The Linux user as which the script actually is run.
4. *DCKR_USR*: The docker user that is used to add to the docker group. This is taken from the _dockerUser_ property from the  [provisioners.yml](../provisioners.yml). And would be most likely the same user as the user that runs the script. 

The _dockerUser_ would be the user that is to be added to the Docker Group, to be able to connect to the Docker Daemon to start and stop containers.

To pass the docker user to the install script, a property file is created, by expanding the [dockerUser.properties.tpl](../scripts/opensource/docker/dockerUser.properties.tpl) to [dockerUser.properties](../scripts/opensource/docker/dockerUser.properties).

Then the [co8InstallDocker.sh](../scripts/opensource/docker/co8InstallDocker.sh) script is called.


## co8InstallDocker.sh
This script is a scripted version of the steps documented at [Docker Docs: Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/). 
Since CentOS is the upstream version of Red Hat Enterprise Linux (RHEL), it should work for other RHEL based distributions, including Oracle Linux 8. 
For RHEL based distributions only the IBM s390 architecture is supported.

The script performs the following steps.

### Get the Docker user
To get the docker user, a function _prop_ is used to fetch the _docker.user_ property from [dockerUser.properties](../scripts/opensource/docker/dockerUser.properties).

### Remove Old Docker Related packages
First old Docker related packages including _podman_ and _buildah_ are removed. Older versions may have been installed with the distribution.

### Install Docker Engine
To install Docker Engine the CentOS docker repository is to be added.
Then the Docker Engine is installed, including plugins. As an extra, also _Curl_ is installed, if not available already. In most Container related developments, Curl is an appreciated tool.

### Add the Docker user to the Docker group
The Linux user group _docker_ is created and the provided Docker user is added to the group.

###  Check Docker install
The installed Docker version is shown, and started as a Service.

### Change Docker default folder
By default, Docker saves the downloaded and or created images to a default location _/var/lib/docker_ on the boot disk. The boot disk is often limited to install Linux. 
I don't want to have my applications or my project data saved to the boot disk. That's why one the first steps in provisioning VMs is to add an initialize a second disk. 
I used the article [How to move the default /var/lib/docker to another directory for Docker on Linux?](https://www.digitalocean.com/community/questions/how-to-move-the-default-var-lib-docker-to-another-directory-for-docker-on-linux) to adapt the Docker setup to use a folder structure under _/app/docker/data_.

This part of the script stops the Docker daemon. 
Then it will create the new data folder _/app/docker/data_. 
The file _/lib/systemd/system/docker.service_ is filtered to check if the change is not already done. It searches for the string _ExecStart=/usr/bin/dockerd_ and expands that to *ExecStart=/usr/bin/dockerd --data-root /app/docker/data*.

When that is done, it will reaload the daemon and starts it again.

### Enable docker as a systemd service
As a [post install step](https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot) it will enable _docker_ and _containerd_ services.

### Set file attributes correct to connect to the Docker Daemon
Although the Docker user is added to the Docker Group, it might run into a permission denied error. This might be due to wrong file attributes on the _/var/run/docker.sock_ file. 
So, the file attributes are set as suggested in [Stackoverflow: How to fix docker: Got permission denied issue](https://stackoverflow.com/questions/48957195/how-to-fix-docker-got-permission-denied-issue).

