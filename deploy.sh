#!/bin/bash
#
# Deploy the stuff!
#
# Wrapper around `terraform apply` and `ansible-playbook`.
#

set -e  # fail on errors

. config.sh

force=0
while [ $# -gt 0 ]
do
  case "$1" in
    -f|--force)
      force=1
      shift
    ;;
    *)
      echo "Invalid argument: $1"
      echo "Usage: $0 [-f|--force]"
      exit 1
    ;;
  esac
done

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
export TF_VAR_symbolic_name=$SYMBOLIC_NAME
export TF_VAR_aws_account_id=`aws iam get-user --output text | awk '{print $2}' | awk -F: '{print $5}'`

cd terraform 
terraform="terraform apply"
[ "$force" == "1" ] && terraform="$terraform -auto-approve"
echo
echo '**************************************************'
echo '**'
echo '**  Running terraform apply'
echo '**'
echo '**************************************************'
echo
$terraform
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

playbook="ansible-playbook \
 -b \
 --key-file `pwd`/ssh-key \
 -u ubuntu \
 -i $hosts \
 --extra-vars \"linkedin_profile='$LINKEDIN_PROFILE' resume_file='$RESUME_FILE' resume_base='`basename $RESUME_FILE`' domain='$DOMAIN' symbolic_name='$SYMBOLIC_NAME'\" \
 ansible/playbook.yml \
"

if [ "$force" != 1 ]
  then
  echo
  echo '**************************************************'
  echo '**'
  echo '**  Running ansible-playbook check'
  echo '**'
  echo '**************************************************'
  echo
  bash -c "$playbook -CD"
  echo
  echo
  read -p "Does everything look OK? yes/no " yesno
  if ! echo "$yesno" | grep -Eiq '^y($|es)$'
  then
    echo 'Abort!'
    exit 1
  fi
fi

echo
echo '**************************************************'
echo '**'
echo '**  Running ansible-playbook'
echo '**'
echo '**************************************************'
echo
bash -cx "$playbook"


echo
echo '**************************************************'
echo '**'
echo '**  ALL DONE! Running some tests (Ctrl+C to skip)'
echo '**'
echo '**************************************************'
echo


echo 'Sleeping for 5 minutes first. It can take a while for DNS to settle. :('
sleep 300
echo 'Done waiting...'
failed=0

for url in https://linkedin.$DOMAIN https://message.$DOMAIN https://chat.$DOMAIN
do
  echo -n "Testing $url for redirect... "
  if curl -s $url | grep -q 'https://www.linkedin.com/.*redirected automatically'
  then
    echo 'OK'
  else
    echo 'FAILED!'
    failed=1
  fi
done

for url in https://resume https://xn--rsum-bpad
do
  echo -n "Testing $url.[...] for PDF... "
  url="$url.$DOMAIN"
  if curl -s $url | file - | grep -q 'PDF.*pages'
  then
    echo 'OK'
  else
    echo 'FAILED!'
    failed=1
  fi
done

if [ "$failed" = "1" ]
then
  echo
  banner -w 60 fail
  echo
  echo
  echo 'FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!'
  echo 'FAIL!                                        FAIL!'
  echo 'FAIL!  TESTS DID NOT PASS! I NEED A HUMAN!!  FAIL!'
  echo 'FAIL!                                        FAIL!'
  echo 'FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!'
  echo
  exit 1
else
  echo 'Success!'
fi
