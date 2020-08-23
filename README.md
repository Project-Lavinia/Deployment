# Deployment
This repository contains all deployment and server configuration details for Lavinia.

## Requirements
 - A linux machine/VM (This document will use Ubuntu as reference)
 - Terraform ( >= 0.13.0, [download page](https://www.terraform.io/downloads.html))
 - Ansible ( >= 3.8.2, `apt-get install ansible`)
 - Openstack client (should be installed automatically by terraform, >= 5.3.1, `pip3 install python-openstackclient`)
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
3. Generate a second key in the directory `~/.ssh/jenkins/`
4. Log into your domain registrar and change the name servers of your domain as according to [this guide](https://docs.nrec.no/dns.html#when-to-use-the-dns-service). (If you encounter problems, try using ns1.uh-iaas.no and ns2.uh-iaas.no, instead of the nrec domain)
5. In `Deployment/terraform` do `terraform apply`
6. In `Deployment/ansible` do:
    1. `ansible-playbook -i inventory api.yaml`
    2. `ansible-playbook -i inventory web.yaml`
    3. `ansible-playbook -i inventory load_balancer.yaml`
    4. `ansible-playbook -i inventory jenkins.yaml`
7. Open `https://jenkins.<your domain>` in your browser
8. In Jenkins, log in with username: admin, password: admin, and **immediately change the password**
9. In Jenkins, install the following jenkins plugins:
    * Blue Ocean
    * Ansible plugin
    * SSH Credentials Plugin
    * Basic Branch Build Strategies Plugin
10. In Github -> Personal access tokens: Create a new access token called Jenkins_Hooks with the permission: `admin:org_hook`
11. In Jenkins -> Manage Jenkins -> Configure System -> GitHub:
    * Name: `GitHub`
    * API URL: leave the default value
    * Credentials -> Add -> Jenkins:
        * Domain: Global credentials
        * Kind: Secret text
        * Scope: System
        * Secret: the Jenkins_Hooks access token
        * ID: `github_hooks`
        * Description: `Github Hooks`
    * Manage hooks: checked
12. In Github -> Personal access tokens: Create a new access token called Jenkins_Release with the permission: `repo`
13. In Jenkins -> Manage Jenkins -> Manage Credentials -> Stores: Jenkins -> System: Global credentials -> Add Credentials:
    * Kind: Secret text
    * Scope: Global
    * Secret: the Jenkins_Release access token
    * ID: `jenkins_release_token`
    * Description: `Github token for uploading releases`
14. In Jenkins -> Manage Jenkins -> Manage Credentials -> Stores scoped to Jenkins: Jenkins -> System: Global credentials -> Add Credentials:
    * Scope: Global
    * ID: `ansible_key`
    * Description: `SSH key for Ansible`
    * Username: `centos`
    * Private Key: Enter directly -> Paste the contents of the file `~/.ssh/jenkins/id_rsa`
    * Passphrase: Leave empty
15. In Jenkins -> Blue Ocean: create two new pipelines (for Lavinia-API and Lavinia-Client), it should assist you with GitHub configuration
16. For each pipeline, In Jenkins -> Pipeline -> Configure -> Behaviors: Edit the Behaviors so they contain exactly:
    * Discover branches (Exclude branches that are also filed as PRs)
    * Discover pull requests from origin (Merging the pull request with the current target branch revision)
    * Discover tags
    * Clean before checkout (Delete untracked nested repositories: checked)
    * Clean after checkout (Delete untracked nested repositories: checked)
17. For each pipeline, In Jenkins -> Pipeline -> Configure -> Build strategied -> Add:
    * Tags (Ignore tags newer than: (leave empty), Ignore tags older than: 7)
    


## Add/remove web/api instances
It is safe to modify both the number of web and api instanced at the same time, just perform the actions for both web and api at the points where you should do one or the other.

1. Modify the number of instances in `Deployment/terraform/variables.tf`
2. In the `Deployment/terraform` directory, use the command `terraform apply`
3. In the `Deployment/ansible` directory, do:
    1. `ansible-playbook -i inventory api.yaml` or `ansible-playbook -i inventory web.yaml`
    2. `ansible-playbook -i inventory load_balancer.yaml`
    3. `ansible-playbook -i inventory jenkins.yaml`