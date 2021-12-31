#!/bin/bash
#
# Deploy the stuff!
#
# Wrapper around `terraform apply` and `ansible-playbook`.
#

set -e  # fail on errors

. config.sh

if [ -z "$RESUME_FILE" ]
then
  echo "Specify resume file in config.sh"
  exit 1
  # TODO: check for other required configs.
fi
if [ ! -f "$RESUME_FILE" ]
then
  echo "File $RESUME_FILE doesn't exist!"
  exit 1
fi
domain=$1

export TF_VAR_cloudflare_api_token=$CLOUDFLARE_API_TOKEN
export TF_VAR_cloudflare_email=$CLOUDFLARE_EMAIL
export TF_VAR_domain=$DOMAIN
export TF_VAR_dmarc_cname=$DMARC_CNAME
export TF_VAR_o365_org=$O365_ORG

cd terraform 
terraform apply
# We only need the public IP address to avoid waiting for ec2.$domain's address record to update.
ec2_ip=`terraform show | awk '$1 ~ /public_ip/ && $3 ~ /[0-9]+\./ {print $3}' | sed -e 's/"//g'`
cd ..

SSH="ssh -o StrictHostKeyChecking=no -i `pwd`/ssh-key ubuntu@$ec2_ip"
while ! $SSH sudo apt-get update
do
  echo "Waiting for $ec2_ip to come up and successfully run 'apt-get update'..."
  sleep 10
done

# Dynamically create temporary ansible hosts file and run playbook. Remove at exit.
hosts=`mktemp`
function cleanup_hosts {
  rm $hosts
}
trap cleanup_hosts EXIT

echo '[servers]'  > $hosts
echo $ec2_ip     >> $hosts

playbook="ansible-playbook -b --key-file `pwd`/ssh-key -u ubuntu -i $hosts --extra-vars \"resume_file='$RESUME_FILE' domain='$DOMAIN'\" ansible/playbook.yml"
echo $playbook

# Run in check mode first.
bash -c "$playbook -CD"

echo
echo
read -p "Does everything look OK? y/n " yesno
if [ "$yesno" = "y" ]
then
  # Run ansible for real!
  bash -c "$playbook"
else
  echo 'Abort!'
  exit 1
fi
