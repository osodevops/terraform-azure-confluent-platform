[<img src="https://osodevops.io/assets/images/logo-purple-b3af53cc.svg" width="250"/>](https://osodevops.io)

# Overview
This module provides the ability to deploy the entire confluent suite on Azure with three simple commands.  It achieves this by leveraging Terraform to build out the Azure infrastructure.  Within this infrastructure exists a container group which runs the docker image [osodevops/cp-ansible](https://github.com/osodevops/docker-cp-ansible) which is used to provision the confluent virtual machines.  This solution is not intended as a hardened production environment but rather provides a way to get running with Confluent on Azure *QUICKLY*.

### Getting Started
#### Requirements
* Terraform, please see [here](https://www.terraform.io/)
* Azure-cli, please see [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

### Pre-Deployment Tasks
##### Generate SSH keys for virtual machines
* From the root of the project, run `./ssh-generation.sh` this will populate keys through the code base which will be used for remote access onto the Confluent servers
* Keep hold of the newly created ./modules/resource_group/oso-confluent.ssh key, this is the key you will use to SSH onto the VMs.

##### Create storage account for Terraform state
* Sign in with [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) (`az login`) 
* Execute `./generate_state.sh` to create a standalone resource group and storage account to be used for terraform state.  If you change any of the values in this script, you will need to update the `backend.tf` files accordingly.

### Terraform Deployment
Terraform is used to provision all required Azure resources, the deployment has been split up into 2 parts:

**Shared:**
- [x] Private Virtual network. 
- [x] Private and public subnets.
- [x] NAT gateway.
- [x] Private DNS zone.
- [x] Bastion Server with public IP.
- [x] Container service for cp-ansible provisioning.

**Confluent:**
- [x] Zookeeper VM with network interface and data disk.
- [x] Broker VM with network interface and data disk.
- [x] Schema Registry VM with network interface and data disk.
- [x] Kafka Connect VM with network interface and data disk.
- [x] KSQL VM with network interface and data disk.
- [x] Rest Proxy VM with network interface and data disk.
- [x] Confluent Control Centre VM with network interface and data disk.
- [x] Public IPs for Control Center and Rest Proxy.

#### Shared Resource Deployments
To deploy from local, navigate to `./shared`, and run `terraform init && terraform plan`.  If you are happy with the output, you can run `terraform apply`

#### Confluent deployment
After the shared resource groups have successfully deployed, you can deploy the confluent VMs.  To do so, navigate to `./confluent`, and run `terraform init && terraform plan`.  If you are happy with the output, you can run `terraform apply` 

### Ansible Deployment
#### Command Line
The terraform deployment deploys an Azure container group into a private subnet which has the ability to provision the newly created VMs with [cp-ansible](https://github.com/confluentinc/cp-ansible).  If you have made any alterations -- prefix, environment, additional instances, etc., you will need to update `./resource_group/ansible-inventory.yml` to reflect this.  Presently the inventory is working on the assumption of a single instance, so should, for example you wish to have 3 zookeeper instances, you would need to add `zookeeper-2.confluent.internal:` and `zookeeper-3.confluent.internal:` to this file otherwise cp-ansible will not attempt to provision these VMs 

To run this container:
```
$ ./run-ansible.sh
```

This process should take approximately 25 mins to complete.

#### Azure Console (alternative deployment method)
Alternatively, aia the Azure Console, simply find the container group named **oso-devops-cp-ansible** in the click the 'Start' button:

![container](./azure_container.png)


### Considerations
##### Cluster customisations
**NOTE**
Sadly there is an [open bug in the azurerm provider](https://github.com/terraform-providers/terraform-provider-azurerm/issues/10888) which is preventing changes to the ansible-inventory.yml from being realised and uploaded (it should be performing an md5 verification on the file).  Until this bug has been solved, you will need to manually update the ansible-inventory.yml file either via CLI, or via the web console.  Once fixed, this will be the process:

All properties/configurations/hostnames for the cluster are stored in the file `./modules/resource_group/ansible-inventory.yml`.  To activate changes made to that file, perform the following operations:
* Change `./modules/resource_group/ansible-inventory.yml` as desired
* Deploy inventory into the Azure storage account by navigating to `./production/resource_group`, and running `terragrunt apply`
* Run `./run-ansible.sh`



##### Debugging Ansible
As ansible is run from a container within the Azure network, we need away to debug when things aren't working as expected.  To provide this ability, we simply need to uncomment out the `commands = ["sleep", "100000"]` on `resource "azurerm_container_group" "ansible"` found at .`/modules/resource_group/ansible-container.tf` (and then deploy these changes).  Once this is done, you will be able to exec onto this container from the Azure Console, and run ansible manually, or tweak configuration/code in-place.

##### Additional Environments
By using terragrunt's DRY approach, creating additional environments is very straight forward.  Simply copy the entire `production` folder to a new folder (i.e named `staging`), and you will be able to deploy in the same manner as production (The deployments are folder name aware).

## Help

**Got a question?**

File a GitHub [issue](https://github.com/osodevops/azure-terraform-module-confluent/issues), send us an [email][email] or tweet us [twitter][twitter].

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/osodevops/azure-terraform-module-confluent/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2019-2020 [OSO DevOps](https://osodevops.io)

## License

See [LICENSE](LICENSE) for full details.

## About

[<img src="https://osodevops.io/assets/images/logo-purple-b3af53cc.svg" width="250"/>](https://osodevops.io)

We are a cloud consultancy specialising in transforming technology organisations through DevOps practices.
We help organisations accelerate their capabilities for application delivery and minimize the time-to-market for software-driven innovation.

Check out [our other projects][github], [follow us on twitter][twitter], or [hire us][hire] to help with your cloud strategy and implementation.

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

[logo]: https://osodevops.io/assets/images/logo-purple-b3af53cc.svg
[website]: https://osodevops.io/
[github]: https://github.com/orgs/osodevops/
[hire]: https://osodevops.io/contact/
[linkedin]: https://www.linkedin.com/company/oso-devops
[twitter]: https://twitter.com/osodevops
[email]: https://www.osodevops.io/contact/
