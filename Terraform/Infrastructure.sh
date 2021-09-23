#! /bin/bash
if [[ -f "../Ansible/hosts" ]]
then
rm -rf ../Ansible/hosts
fi
terraform apply -auto-approve
terraform refresh
echo "[nodes]" >> ../Ansible/hosts
terraform output --raw ip_address >> ../Ansible/hosts
echo " ansible_user=$(terraform output --raw admin_username) ansible_become_pass=$(terraform output --raw admin_password)" >> ../Ansible/hosts