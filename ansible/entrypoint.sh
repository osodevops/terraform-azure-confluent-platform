#!/bin/bash
cp /root/staging/id_rsa /root/.ssh
chmod 400 /root/.ssh/id_rsa
/ansible/bin/ansible-playbook /ansible/playbooks/cp-ansible/all.yml