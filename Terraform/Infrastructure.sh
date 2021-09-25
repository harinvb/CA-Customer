#! /bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")" || exit
HOSTS="../Ansible/hosts"
TERRA="../Terraform"
if [[ -f $HOSTS ]]
then
rm -rf $HOSTS
fi
touch $HOSTS
#terraform -chdir=$TERRA init
#terraform -chdir=$TERRA apply -auto-approve || terraform -chdir=$TERRA refresh
{
echo "[nodes]";
terraform -chdir=$TERRA output --raw ip_address;
echo " ansible_user=$(terraform -chdir=$TERRA output --raw admin_username) ansible_become_pass=$(terraform -chdir=$TERRA output --raw admin_password)";
} > $HOSTS
