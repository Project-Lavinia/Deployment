# Deployment
This repository contains all deployment and server configuration details for Lavinia.

## Requirements
 <!--- I think terraform grabs this client automatically, but not sure.
 - Openstack client ( >= 5.3.1, `pip3 install python-openstackclient`)
  -->
 - A linux machine/VM (This document will use Ubuntu as reference)
 - Terraform ( >= 0.13.0, [download page](https://www.terraform.io/downloads.html))
 - Ansible ( >= 3.8.2, `apt-get install ansible`)
 - An NREC API password
 - A Lavinia SSH key (If contributing to the current setup)
 - A registered domain name (If setting up new instance)

## First time set-up
1. `git pull https://github.com/Project-Lavinia/Deployment.git`
2. Create the file `Deployment/keystone_rc.sh` as explained in [this guide](https://docs.nrec.no/api.html#using-the-cli-tools).
3. Create the file: `Deployment/ansible/private.yaml` with the content: `letsencrypt_email: <email of project admin>`
4. In `Deployment/ansible`, setup the ansible inventory as per [this guide](https://docs.nrec.no/terraform-part4.html#ansible-inventory-from-terraform-state) (The inventory directory should have the path `Deployment/ansible/inventory`)
5. In `Deployment/terraform/terraform.tfvars` modify which IPs should have http/ssh access to the servers.
6. In `Deployment/terraform/variables.tf` modify the flavour and number of each server type, as well as the domain that should be used.
7. Go through the rest of the terraform files and ensure that you are happy with the settings.
8. In `Deployment` do `source keystone_rc.sh`
9. In the `Deployment/terraform` directory, use the command `terraform init`

## Set up a new instance
1. Complete the First time set-up.
2. Generate an SSH key pair by following the first code-block of [this guide](https://docs.nrec.no/create-virtual-machine.html#importing-an-existing-key).
3. Make a copy of the key `sudo cp ~/.ssh/id_rsa ~/.ssh/id_rsa.rsa`
4. Convert the new key from OpenSSH to RSA (Used by Jenkins) `sudo ssh-keygen -p -N "" -m pem -f ~/.ssh/id_rsa.rsa`
5. Log into your domain registrar and change the name servers of your domain as according to [this guide](https://docs.nrec.no/dns.html#when-to-use-the-dns-service). (If you encounter problems, try using ns1.uh-iaas.no and ns2.uh-iaas.no, instead of the nrec domain)
6. In `Deployment/terraform` do `terraform apply`
7. In `Deployment/ansible` do:
    1. `ansible-playbook -i inventory api.yaml`
    2. `ansible-playbook -i inventory web.yaml`
    3. `ansible-playbook -i inventory load_balancer.yaml`
    4. `ansible-playbook -i inventory jenkins.yaml`
8. Open `https://jenkins.<your domain>` in your browser
9. In Jenkins, log in with username: admin, password: admin, and **immediately change the password**
10. In Jenkins, install the following jenkins plugins:
    * Blue Ocean
    * Pipeline Utility Steps
    * Publish Over SSH
11. In Github -> Personal access tokens: Create a new access token called Jenkins_Hooks with the permission: `admin:org_hook`
12. In Jenkins -> Manage Jenkins -> Configure System -> GitHub:
    * Name: `GitHub`
    * API URL: leave the default value
    * Credentials -> Add -> Jenkins:
        * Domain: Global credentials
        * Kind: Secret text
        * Scope: System
        * Secret: the Jenkins_Hooks access token
        * ID: github_hooks
        * Description: Github Hooks
    * Manage hooks: checked
13. In Jenkins -> Manage Jenkins -> Configure System -> Publish over SSH:
    * Passphrase: leave it empty
    * Path to key: /storage/.ssh/id_rsa
    * SSH Servers: Add a server for each web and api instance (Here is a web example. Api instances would be api-0, api-1, etc. instead):
        * Name: web-0 (the number is the index of the instance)
        * Hostname: web-0.example.com (replace example.com with your domain)
        * Username: centos
        * Remote Directory: \<web_root>/ (**Note the trailing forward-slash**. Replace \<web-root> with what is defined in `Deployment/ansible/paths.yaml`, for api use netcore_path instead.)
14. In the `Lavinia-client` repository edit the `Jenkinsfile`. Copy the sshPublisherDesc section once for each web instance you have created, and change the configName to match each instance name. Eg. web-0, web-1, etc.
15. Repeat the step above in the `Lavinia-api` repository, but use the names api-0, api-1, etc. instead.
16. When all the changes are pushed to the respective repositories; in Jenkins -> Blue Ocean and create two new pipelines (for Lavinia-API and Lavinia-Client), it should assist you with GitHub configuration
17. If the previous step did not initialise a new build of each pipeline, do so manually.
    


## Add/remove web/api instances
It is safe to modify both the number of web and api instanced at the same time, just perform the actions for both web and api at the points where you should do one or the other.

1. Modify the number of instances in `Deployment/terraform/variables.tf`
2. In the `Deployment/terraform` directory, use the command `terraform apply`
3. In the `Deployment/ansible` directory, do:
    1. `ansible-playbook -i inventory api.yaml` or `ansible-playbook -i inventory web.yaml`
    2. `ansible-playbook -i inventory load_balancer.yaml`
    3. `ansible-playbook -i inventory jenkins.yaml`
4. In the `Lavinia-client` or `Lavinia-api` repository edit the `Jenkinsfile`. Copy the sshPublisherDesc section or remove copies of it, for each web instance you have created/removed. Ensure that the remaining config names match the names of the remaining instances.
5. In Jenkins -> Manage Jenkins -> Configure System -> Publish over SSH -> SSH Servers: Add/remove a server for each web and api instance (Here is a web example. Api instances would be api-0, api-1, etc. instead):
    * Name: web-0 (the number is the index of the instance)
    * Hostname: web-0.example.com (replace example.com with your domain)
    * Username: centos
    * Remote Directory: \<web_root>/ (**Note the trailing forward-slash**. Replace \<web-root> with what is defined in `Deployment/ansible/paths.yaml`, for api use netcore_path instead.)
6. When the repository changes are pushed to master and the Jenkins configuration has been updated, initialise a new build in the Lavinia-client/Lavinia-api branch.