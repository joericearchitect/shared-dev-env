#!/bin/sh

DEV_ENV_VM_GIT_PROJECTS_DIR = $1
DEV_ENV_VM_APPS_DIR = $2
DEV_ENV_VM_MAVEN_CONF_DIR = $3
DEV_ENV_VM_MAVEN_REPO_DIR = $4
DEV_ENV_VM_AWS_DIR = $5

#
# JRA Development Environment
#  VM Provision Script - This script will "provision" the dev environment VM by installing all prerequisits.
#  Note:  there may be other provisioners that run before or after this script.  Check the Vagrantfile.

echo "."
echo "*********************************************************************************
echo "   Provisioning wdpr dev environment virtual machine..."
echo "     GIT_PROJECTS_DIR = $GIT_PROJECTS_DIR "
echo "     APPS_DIR = $APPS_DIR "
echo "     MAVEN_CONF_DIR = $MAVEN_CONF_DIR "
echo "     MAVEN_REPO_DIR = $MAVEN_REPO_DIR "
echo "     AWS_DIR = $AWS_DIR "
echo "   ."
echo "     DEV_ENV_VM_GIT_PROJECTS_DIR = $DEV_ENV_VM_GIT_PROJECTS_DIR "
echo "     DEV_ENV_VM_APPS_DIR = $DEV_ENV_VM_APPS_DIR "
echo "     DEV_ENV_VM_MAVEN_CONF_DIR = $DEV_ENV_VM_MAVEN_CONF_DIR "
echo "     DEV_ENV_VM_MAVEN_REPO_DIR = $DEV_ENV_VM_MAVEN_REPO_DIR "
echo "     DEV_ENV_VM_AWS_DIR = $DEV_ENV_VM_AWS_DIR "
echo "
echo "*********************************************************************************

echo "."
echo "*********************************************************************************
echo "   Setting up folder permissions..."
echo "*********************************************************************************
sudo chown -R vagrant:vagrant
sudo chown -R vagrant:vagrant $DEV_ENV_VM_GIT_PROJECTS_DIR
sudo chown -R vagrant:vagrant $DEV_ENV_VM_APPS_DIR
sudo chown -R vagrant:vagrant $DEV_ENV_VM_MAVEN_CONF_DIR
sudo chown -R vagrant:vagrant $DEV_ENV_VM_MAVEN_REPO_DIR
sudo chown -R vagrant:vagrant $DEV_ENV_VM_AWS_DIR

echo "."
echo "*********************************************************************************
echo "   updating apt-get and installing common linux tools"
echo "*********************************************************************************
sudo apt-get update -y > /dev/null
sudo apt-get install -y zip > /dev/null
sudo apt-get install -y unzip > /dev/null

echo "."
echo "*********************************************************************************
echo "   Installing Git"
echo "*********************************************************************************
sudo apt-get install git -y > /dev/null

echo "."
echo "*********************************************************************************
echo "   Installing Maven"
echo "*********************************************************************************
sudo apt-get install maven -y > /dev/null
# for Maven, setting a new symbolic link so that maven points to the conf dir that is synced with host machine.
sudo rm /usr/share/maven/conf
sudo ln -s /home/vagrant/workspace/maven/conf /usr/share/maven/conf

echo "."
echo "*********************************************************************************
echo "   Settng symbolic link for git"
echo "*********************************************************************************
sudo ln -s /home/vagrant/workspace/git ~/git

echo "."
echo "*********************************************************************************
echo "   Installing Docker Machine"
echo "*********************************************************************************
sudo curl -L https://github.com/docker/machine/releases/download/v0.8.2/docker-machine-`uname -s`-`uname -m` >~/docker-machine
sudo mv ~/docker-machine /usr/local/bin/docker-machine
sudo chmod +x /usr/local/bin/docker-machine

echo "."
echo "*********************************************************************************
echo "   Installing Terraform"
echo "*********************************************************************************
sudo curl -L https://releases.hashicorp.com/terraform/0.7.13/terraform_0.7.13_linux_amd64.zip >~/terraform_0.7.13_linux_amd64.zip
sudo unzip ~/terraform_0.7.13_linux_amd64.zip -d /usr/local/bin

echo "."
echo "*********************************************************************************
echo "   Installing Packer"
echo "*********************************************************************************
sudo curl -L https://releases.hashicorp.com/packer/0.12.0/packer_0.12.0_linux_amd64.zip >~/packer_0.12.0_linux_amd64.zip
sudo unzip ~/packer_0.12.0_linux_amd64.zip -d /usr/local/bin

echo "."
echo "*********************************************************************************"
echo "   Installing Amazon CLI - Command Line Interface "
echo "*********************************************************************************"
wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
rm awscli-bundle.zip
rm -r awscli-bundle
sudo ln -s /home/vagrant/workspace/.aws /home/vagrant/.aws
complete -C '/usr/local/aws/bin/aws_completer' aws

echo "."
echo "*********************************************************************************
echo "   installing node.js
echo "*********************************************************************************
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y > /dev/null

echo "."
echo "*********************************************************************************
echo "   installing gradle
echo "*********************************************************************************
sudo add-apt-repository ppa:cwchien/gradle -y > /dev/null
sudo apt-get update -y > /dev/null
sudo apt-get install gradle -y > /dev/null

echo "."
echo "*********************************************************************************
echo "   installing imagemagick
echo "*********************************************************************************
sudo apt-get install imagemagick -y > /dev/null

echo "."
echo "*********************************************************************************
echo "   installing PHP
echo "*********************************************************************************
sudo apt-get install build-essential libxml2-dev -y > /dev/null
#wget http://in1.php.net/distributions/php-5.3.29.tar.bz2
#wget http://in1.php.net/distributions/php-7.0.12.tar.bz2


echo "."
echo "*********************************************************************************
echo "   Setting up environment variables - END..."
echo "*********************************************************************************
sudo > /etc/profile.d/dev-env-vars-shell.sh
