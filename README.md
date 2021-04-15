[<img src="https://osodevops.io/assets/images/logo-purple-b3af53cc.svg" width="250"/>](https://osodevops.io)


# aws-terraform-module-tableau

OSO DevOps has developed the Confluent Deployment Library for Azure....


## Requirements
* Terragrunt, please see [here](https://terragrunt.gruntwork.io/)
* Terraform, please see [here](https://www.terraform.io/)
* CP-Ansible, please see [here](https://github.com/confluentinc/cp-ansible)

## Usage

### Usage
The Confluent platform infrastructure is made up of the following resources

```
<environment>
├── broker
│   └── terragrunt.hcl
├── control_centre
│   └── terragrunt.hcl
├── kafka_connect
│   └── terragrunt.hcl
├── ksql
│   └── terragrunt.hcl
└── resource_group
│   └── terragrunt.hcl
├── rest_proxy
│   └── terragrunt.hcl
├── schema_registry
│   └── terragrunt.hcl
├── zookeeper
│   └── terragrunt.hcl
└── env.hcl
```

With the terragrunt framework, we have the ability to deploy a single module (for example, navigating into ./production/zookeerp), and running `terragrunt plan`.  

Alternatively, we could navigate to the root of the environment (i.e. /production), and run `terragrunt run-all plan` to have a plan run against each module 

```
➜  production git:(develop) ✗ terragrunt run-all apply
INFO[0000] Stack at /home/azure-terraform-module-confluent/production:
=> Module /home/azure-terraform-module-confluent/production/broker (excluded: false, dependencies: [/home/azure-terraform-module-confluent/production/resource_group])
=> Module /home/azure-terraform-module-confluent/production/control_centre (excluded: false, dependencies: [/home/azure-terraform-module-confluent/production/resource_group])
=> Module /home/azure-terraform-module-confluent/production/kafka_connect (excluded: false, dependencies: [/home/azure-terraform-module-confluent/production/resource_group])
=> Module /home/azure-terraform-module-confluent/production/ksql (excluded: false, dependencies: [/home/azure-terraform-module-confluent/production/resource_group])
=> Module /home/azure-terraform-module-confluent/production/resource_group (excluded: false, dependencies: [])
=> Module /home/azure-terraform-module-confluent/production/rest_proxy (excluded: false, dependencies: [/home/azure-terraform-module-confluent/production/resource_group])
=> Module /home/azure-terraform-module-confluent/production/schema_registry (excluded: false, dependencies: [/home/azure-terraform-module-confluent/production/resource_group])
=> Module /home/azure-terraform-module-confluent/production/zookeeper (excluded: false, dependencies: [/home/azure-terraform-module-confluent/production/resource_group])
Are you sure you want to run 'terragrunt apply' in each folder of the stack described above? (y/n)
```

### Additional Environments
By using terragrunt's DRY approach, creating additional environments is very straight forward.  Simply copy the entire `production` folder to a new folder (i.e named `staging`), and you will be able to deploy in the same manner as production (The deployments are folder name aware).



TODO:
Things to mention:
- cp-ansible
- terragrunt wrapper

### Diagram
//TODO

#### Features:
//TODO

#### Benefits:
//TODO


## Help

**Got a question?**

File a GitHub [issue](https://github.com/osodevops/aws-terraform-module-tableau/issues), send us an [email][email] or tweet us [twitter][twitter].

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/osodevops/aws-terraform-module-tableau/issues) to report any bugs or file feature requests.

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
