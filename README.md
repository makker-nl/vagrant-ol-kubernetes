# Vagrant - Oracle Linux 8  - Kubernetes 
Vagrant project to install Kubernetes cluster on Oracle Linux 8

## Settings

## Provisioners

| **Name** | **Provisoners.yaml entry** | **Run**| **Run as user** | **Script** | **Description**|
|----------|----------------------------|--------|------------|----------------|
| prepLinux  | preplinux | once | vagrant | /vagrant/scripts/ol8/0.PrepOL.sh | Prepare linux" |
| initFileSystem | initfilesystem | once |  vagrant | /vagrant/scripts/ol8/1.FileSystem.sh | Initialize Filesystem on disk 2 |
| addOracleUser | addoracleuser | once |  vagrant | /vagrant/scripts/ol8/2.MakeOracleUser.sh | Add Oracle User. |

### Prepare Oracle Linux
This script performs the following:
* Upgrade package repository
* Install packages: system-storage-manager
* Install Haveged for entropy maximation
* Disable Swap. This is necessary for Kubernetes. See [Discuss Kubernetes: Swap Off - why is it necessary?](https://discuss.kubernetes.io/t/swap-off-why-is-it-necessary/6879), [GitHub Kubernetes Issue #53533: Kubelet/Kubernetes should work with Swap Enabled]
(https://github.com/kubernetes/kubernetes/issues/53533)
* Enable ssh password login.

### Init File System
This script performs the following:
* Create folder for mountpoint /app
* Create a Logical Volume group and Volume on sdb and initialize it as xfs
* Add the disk pool to fstab to mount on /app

### Add Oracle User
This script performs the following:
* Create group oinstall: also standard, but maybe handy, as a heritage from other scripts.
* Create the Oracle user, using password from _makeOracleUser.properties_
* Add Oracle to sudoers so he can perform admin tasks
* Grant/Change owner /app to oracle:oinstall 
* Create /app/opensource for oracle:oinstall 
