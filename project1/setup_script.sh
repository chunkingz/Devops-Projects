#!/bin/bash

# Connect via ssh
# ssh -i ~/.ssh/ec2_ssh_key ec2-user@IP

# switch to the root user
sudo su -


cat <<EOL > /etc/yum/pluginconf.d/subscription-manager.conf
[main]
enabled=0

# When following option is set to 1, then all repositories defined outside redhat.repo will be disabled
# every time subscription-manager plugin is triggered by dnf or yum
disable_system_repos=0
EOL

yum clean all

# Update the OS
yum update -y

# Create Swap file for extra memory
fallocate -l 512M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Install git
yum install git -y

# Install Java and set PATH
yum install java-11-openjdk-devel -y

# Download Jenkins to EC2 instance
yum install wget -y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

#Install Jenkins
yum install jenkins -y

# Start Jenkins service
systemctl enable jenkins
systemctl restart jenkins
systemctl status jenkins




# >>>>>>>>>>>>>>>>>>>>    MAVEN INSTALL    <<<<<<<<<<<<<<<<<<<<<<


mkdir -p /opt/maven/ && cd /opt/maven/
wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.zip
yum install unzip -y && unzip apache-maven-3.8.6-bin.zip && rm -f apache-maven-3.8.6-bin.zip


# find the javac version installed
# find / -name javac | tail -n 1

# This section may need to be run manually
# Export the Java and Maven path

cat <<EOL > ~/.bash_profile
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.16.1.1-1.el8_6.x86_64
export M2_HOME=/opt/maven/apache-maven-3.8.6
export M2=$M2_HOME/bin
export PATH=$PATH:$JAVA_HOME:$M2_HOME:$M2:$HOME/bin
EOL

source ~/.bash_profile
# echo $JAVA_HOME
# echo $M2_HOME

# check Java and Maven version
java -version
mvn --version

# visit the jenkins frontend via IP:8080 (remove https if any)
# Get Jenkins password
cat /var/lib/jenkins/secrets/initialAdminPassword

# Github repo 
# https://github.com/chunkingz/maven-hello-world.git

# Goals and options
# clean install package




# >>>>>>>>>>>>>>>>>>>>    TOMCAT INSTALL    <<<<<<<<<<<<<<<<<<<<<<

# See https://github.com/chunkingz/Simple-DevOps-Project/blob/master/Tomcat/tomcat_installation.MD


cd /opt/
wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.82/bin/apache-tomcat-8.5.82.zip
unzip apache-tomcat-8.5.82.zip && rm -f apache-tomcat-8.5.82.zip
chmod +x apache-tomcat-8.5.82/bin/*.sh 
ln -s /opt/apache-tomcat-8.5.82/bin/startup.sh /usr/local/bin/tomcatup
ln -s /opt/apache-tomcat-8.5.82/bin/shutdown.sh /usr/local/bin/tomcatdown


# This section may need to be run manually
# update port number in the "Connector port" field in server.xml to 8090
# vi /opt/apache-tomcat-8.5.82/conf/server.xml
# in vi type / <Connector port="8080" to search and change "8080" to "8090"


# find the below files 
# in vi search for "Valve className" and comment it out
# vi /opt/apache-tomcat-8.5.82/webapps/host-manager/META-INF/context.xml
# vi /opt/apache-tomcat-8.5.82/webapps/manager/META-INF/context.xml


# update the user file below with the roles and users 
# vi /opt/apache-tomcat-8.5.82/conf/tomcat-users.xml

# <role rolename="manager-gui"/>
# <role rolename="manager-script"/>
# <role rolename="manager-jmx"/>
# <role rolename="manager-status"/>
# <user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
# <user username="deployer" password="deployer" roles="manager-script"/>
# <user username="tomcat" password="s3cret" roles="manager-gui"/>


# Restart Tomcat
tomcatdown && tomcatup

# To check if Tomcat is running
# ps -ef | grep tomcat

# After run, to see where the deployed war file is
# ls -la /opt/apache-tomcat-8.5.82/webapps/

