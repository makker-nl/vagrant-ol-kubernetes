# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# 20230302 - M. van den Akker: Taken from https://github.com/kodekloudhub/certified-kubernetes-administrator-course/blob/master/Vagrantfile.
# See also: https://developer.hashicorp.com/vagrant/docs/multi-machine
#
# Generic settings
BOX_NAME = "oraclebase/oracle-8"
#
# https://stackoverflow.com/questions/13065576/override-vagrant-configuration-settings-locally-per-dev
settings = YAML.load_file 'settings.yml'
provisioners = YAML.load_file 'provisioners.yml'
# Environment settings
VMS_HOME = settings['environment']['vmsHome']
LOCAL_SCRIPTS = 'scripts'
REMOTE_SCRIPTS = '/vagrant/scripts'
RUN_AS_SCR = LOCAL_SCRIPTS+'/runAs.sh'
#
# Define the number of master and worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.
NUM_MASTER_NODE = settings['master']['numOfNodes']
NUM_WORKER_NODE = settings['worker']['numOfNodes']
# Network Settings
IP_NW = settings['environment']['ipNetwork']
MASTER_IP_START = settings['master']['ipStart']
MASTER_SSH_PORT_START = settings['master']['sshPortStart']
NODE_IP_START = settings['worker']['ipStart']
NODE_SSH_PORT_START = settings['worker']['sshPortStart']
#
# Add a shared folder based on a setting
def add_shared_folder(vmconf, sharedfolder)   
    vmconf.vm.synced_folder sharedfolder['hostFolder'], sharedfolder['guestFolder']
end
#
# Add a disk to VirtualBox VM
def add_vbx_shared_disk(vbx, vbName, diskProperty, nodeSettings)
  storage_controller = nodeSettings['disks']['controller']
  disk = nodeSettings['disks'][diskProperty]
  vm_disk=VMS_HOME+"/"+vbName+"/"+vbName+"-"+disk['name']+".vdi"
  # Create a disk  
  unless File.exist?(vm_disk)
    vbx.customize [ "createmedium", "disk", "--filename", vm_disk, "--format", "vdi", "--size", disk['size'] , "--variant", "Standard" ]
  end
  # Add it to the VM.
  vbx.customize [ "storageattach", :id , "--storagectl", storage_controller, "--port", "2", "--device", "0", "--type", "hdd", "--medium", vm_disk]
end
#
# Provision generic.
def provision(vmconf, provisioner)
  keys =  provisioner.keys
  provisionerName = provisioner['name']
  description = provisioner['description']
  runAsUser = provisioner['user']
  runType = provisioner['run']
  if provisioner['commonScript'] then
    script = STAGE_COMMON_SCRIPTS+'/'+provisioner['commonScript']
  elsif provisioner['absoluteScript'] then
    script = provisioner['absoluteScript']
  end  
  if  provisioner['arg']
     vmconf.vm.provision provisionerName, type: "shell", run: runType, path: RUN_AS_SCR, args: [description, script, runAsUser, provisioner['arg']]
  else
    vmconf.vm.provision provisionerName, type: "shell", run: runType, path: RUN_AS_SCR, args: [description, script, runAsUser]
  end  
end
#
# Provision docker
def vagrantProvisionDocker(vmconf, provisioner)
  provisionerName = provisioner['name']
  description = provisioner['description']
  runType = provisioner['run']
  runAsUser = provisioner['user']
  runType = provisioner['run']
  dockerUser = provisioner['dockerUser']
  scriptHome = provisioner['scriptHome']
  docker_run_as_scr = LOCAL_SCRIPTS + provisioner['commonScript']
  vmconf.vm.provision provisionerName, type: "shell", run: "never", run: runType, path: docker_run_as_scr, args: [description, scriptHome, runAsUser, dockerUser]
end
#
# Configure VMs
Vagrant.configure("2") do |config|
  config.vm.box = BOX_NAME
  
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false
  # Global provisioners
  # For selecting which provisioner is run where, see:
  # https://stackoverflow.com/questions/57913410/vagrant-multi-machine-provisions-every-machine
  provision(config, provisioners['preplinux'])
  provision(config, provisioners['initfilesystem'])
  provision(config, provisioners['addoracleuser'])
  provision(config, provisioners['setuphosts'])
  provision(config, provisioners['updatedns'])       
  provision(config, provisioners['setupbridgedtraffic'])
  vagrantProvisionDocker(config, provisioners['docker'])
  provision(config, provisioners['cri-docker'])
  provision(config, provisioners['installkubeclis'])
  # Provision Master Nodes
  (1..NUM_MASTER_NODE).each do |i|
      config.vm.define settings['master']['machine']+"-#{i}" do |node|
        nodeSettings=settings['master']
        STAGE_GUEST_FOLDER=nodeSettings['sharedFolders']['stage']['guestFolder']
        STAGE_COMMON_SCRIPTS = STAGE_GUEST_FOLDER+"/commonScripts"        
        # VirtualBox settings
        node.vm.provider "virtualbox" do |vb|
            vbName  = nodeSettings['name']+"-#{i}"
            vb.name = vbName
            vb.memory = nodeSettings['vmMemory']
            vb.cpus = nodeSettings['vmCpus']
            # Add second disk
            add_vbx_shared_disk(vb, vbName, 'disk2', nodeSettings)
        end
        # Node Config settings
        node.vm.hostname = nodeSettings['hostname']+"-#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{MASTER_IP_START + i}"
        node.vm.network "forwarded_port", guest: 22, host: "#{MASTER_SSH_PORT_START + i}"
        # Add Shared Folders
        add_shared_folder(node, nodeSettings['sharedFolders']['stage']) 
        add_shared_folder(node, nodeSettings['sharedFolders']['project']) 
        # Node provisioners
        provision(node, provisioners['kubeadmin-init'])
        provision(node, provisioners['weavenet'])
        provision(node, provisioners['genjoinclusterscript'])
      end
  end
  # Provision Worker Nodes
  (1..NUM_WORKER_NODE).each do |i|
     config.vm.define settings['worker']['machine']+"-#{i}" do |node|
        nodeSettings=settings['worker']
        STAGE_GUEST_FOLDER=nodeSettings['sharedFolders']['stage']['guestFolder']
        STAGE_COMMON_SCRIPTS = STAGE_GUEST_FOLDER+"/commonScripts"        
        # VirtualBox settings
        node.vm.provider "virtualbox" do |vb|
            vbName  = nodeSettings['name']+"-#{i}"
            vb.name = vbName
            vb.memory = nodeSettings['vmMemory']
            vb.cpus = nodeSettings['vmCpus']
            # Add second disk
            add_vbx_shared_disk(vb, vbName, 'disk2', nodeSettings)
        end
        # Node Config settings
        node.vm.hostname = nodeSettings['hostname']+"-#{i}" 
        node.vm.network :private_network, ip: IP_NW + "#{NODE_IP_START + i}"
        node.vm.network "forwarded_port", guest: 22, host: "#{NODE_SSH_PORT_START + i}"
        # Add Shared Folders
        add_shared_folder(node, nodeSettings['sharedFolders']['stage']) 
        add_shared_folder(node, nodeSettings['sharedFolders']['project']) 
        # Node Provisioners
        provision(node, provisioners['joincluster'])
    end
  end
  
end