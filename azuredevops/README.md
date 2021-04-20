**NOTE: Very WIP notes that need some maturity...

GitHub Requirements

Azure must have access to organisation

Need to manually add build and deployment pipelines

run az repos list to find out repo ID

Talk about https://hub.docker.com/r/devopsinfra/docker-terragrunt


go to https://github.com/apps/azure-pipelines and install azure pipelines for git

* User needs to be admin on repo permissions (in order to create hoooks)


navigate to:
RUN:
'/home/mccullya/Projects/azure/azure-terraform-module-confluent/modules/confluent_node'
➜  confluent_node git:(develop-mccullya) ✗ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/mccullya/.ssh/id_rsa): oso-confluent-ssh



getting ansible running on broker...

sudo yum install git rh-python36 -y
scl enable rh-python36 bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
python3 -m pip install ansible
pip install --upgrade pip
