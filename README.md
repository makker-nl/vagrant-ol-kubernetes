# Vagrant - Oracle Linux 8  - Kubernetes 
Vagrant project to install Kubernetes cluster on Oracle Linux 8
This project is based on [Certified Kubernetes Administrator (CKA) Course](https://github.com/kodekloudhub/certified-kubernetes-administrator-course).
However, I made it configurable through both the [settings.yml]

## Settings

## Provisioners

| **Name** | **Provisoners.yaml entry** | **Description** |  **Run as user** | **Run** | **Script** | 
| -------- | -------------------------- | --------------- | ------- | --------------- | ---------- |
| prepLinux  | preplinux |  Prepare linux | vagrant | once |/vagrant/scripts/ol8/0.PrepOL.sh |
| initFileSystem | initfilesystem | Initialize Filesystem on disk 2 | vagrant | once | /vagrant/scripts/ol8/1.FileSystem.sh |
| addOracleUser | addoracleuser | Add Oracle User. | vagrant | once | /vagrant/scripts/ol8/2.MakeOracleUser.sh |
| setuphosts | setupHosts | Setup Hosts | vagrant | never | /vagrant/scripts/setup-hosts.sh |
| updateDNS | updatedns | Update DNS | vagrant | never | /vagrant/scripts/update-dns.sh |
| setupBridgedTraffic | setupbridgedtraffic | Setup BridgedTrafic. | vagrant | never | /vagrant/scripts/setup-bridged-traffic.sh | 
| installDocker | docker |  Docker | oracle | never | /opensource/docker/co8InstallDockerAs.sh | 
| installCRIDocker | cri-docker| CRI-Docker. | oracle | never | /vagrant/scripts/install-cri-docker.sh | 
| installKubeCLIs | installkubeclis | Kubernetes CLIs | oracle | never | /vagrant/scripts/install-kube-clis.sh | 
| kubeadmInit | kubeadminInit | Kubeadm Init | oracle | never | /vagrant/scripts/kubeadm-init.sh | 
| installWeave | weavenet | Install latest Weave | oracle | never | /vagrant/scripts/install-weave.sh |


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

## Take Snapshots
The (Windows) script [takesnapshots.cmd](takesnapshots.cmd) creates a current snapshot for each of the VMs (kubemaster-1, kubeworker-1, and kubeworker-2.). The snapshots are indicated by the current date.