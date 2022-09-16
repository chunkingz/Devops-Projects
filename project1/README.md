
# DevOps Project 1 - for CI/CD via Jenkins


## Tools used:

- Terraform
- Git 
- Java
- Jenkins
- Amazon EC2 (CentOS/RHEL)
- Maven
- Tomcat


## Terraform Commands

Initialize the deployment
```
terraform init
```

Plan the deployment of resources without making changes
```
terraform plan
```

Deploy the resources to Amazon EC2
```
terraform apply --auto-approve
```

Optional: Delete all the deployed resources
```
terraform destroy --auto-approve
```

> Run the shell commands as seen in `setup_script.sh`




## How to use

Clone the Git repo, run the terraform commands.

After deploying the resources to Amazon EC2, give the instance around 7 - 10 mins to finish running the `setup_script.sh`, you can check uptime with the `uptime` command in bash.

You can confirm that the script has completed the run by logging in to the instance using your private key: `ssh -i ~/.ssh/ec2_ssh_key ec2-user@IP`

After SSHing to the machine, run `java -version` to check if the OpenJDK has been installed along side other tools, else allow a couple of more minutes.

Look for sections in the `setup_script.sh` script that says `# This section may need to be run manually` and run them manually.




## Jenkins Plugins

After installing the recommended plugins, you should install these as well.

- Maven Integration
- Deploy to Container



## Jenkins Global Tool Config

### JDK installation

Find the javac version installed and put it in JAVA_HOME:

```
find / -name javac | tail -n 1
```

- Name: `Java`
- JAVA_HOME: `/usr/lib/jvm/java-11-openjdk-11.0.16.1.1-1.el8_6.x86_64`


### Maven installation

- Name: `Maven`
- MAVEN_HOME: `/opt/maven/apache-maven-3.8.6`


### Build

- Jenkins homepage > New Job > Maven Project > maven-hello-world
- Github Repo: `https://github.com/chunkingz/maven-hello-world.git`
- Goals: `clean install package`



## Bonus Optional Commands:

- to apply a specific resource: `terraform apply -target`

- to delete a specific resource: `terraform destroy -target`

- for printing the output values without deploying: `terraform refresh`

- to see the outputs if any: `terraform output`

