#!/usr/bin/env bash
#
# Deploy the stuff!
#
# Wrapper around `terraform apply`.
#

# Fail on errors.
set -e

# Check dependencies.
if echo "$BASH_VERSION" | grep -q '^[0-3]\.'
then
  echo "I need a bash version that supports associative arrays (>= 4.x)"
  echo "If you're on MacOS, try installing bash from homebrew: brew install bash"
  exit 1
fi

declare -A tests

# Run in script's working directory.
cd -- `dirname -- "${BASH_SOURCE[0]}"`

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
PROFILE_PHOTO_BASE=`basename $PROFILE_PHOTO`
RESUME_FILE_BASE=`basename $RESUME_FILE`
domain=$1

mkdir -p terraform/tmp
cp "$PROFILE_PHOTO" "$RESUME_FILE" terraform/tmp/
# CAREFUL
trap "rm -rf \"`pwd`/terraform/tmp\"" EXIT
export TF_VAR_cloudflare_api_token=$CLOUDFLARE_API_TOKEN
export TF_VAR_cloudflare_account_id=$CLOUDFLARE_ACCOUNT_ID
export TF_VAR_cloudflare_email=$CLOUDFLARE_EMAIL
export TF_VAR_domain=$DOMAIN
export TF_VAR_dmarc_record=$DMARC_RECORD
export TF_VAR_spf_record=$SPF_RECORD
export TF_VAR_symbolic_name=$SYMBOLIC_NAME
export TF_VAR_linkedin_profile=$LINKEDIN_PROFILE
export TF_VAR_email=$EMAIL
export TF_VAR_phone=$PHONE
export TF_VAR_profile_photo_base=$PROFILE_PHOTO_BASE
export TF_VAR_resume_file_base=$RESUME_FILE_BASE
export TF_VAR_full_name=$FULL_NAME
export TF_VAR_dd_api_key=$DD_API_KEY
export TF_VAR_dd_app_key=$DD_APP_KEY
export TF_VAR_calendly_profile=$CALENDLY_PROFILE

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


linkedin_test="grep -q Redirecting.*https://www.linkedin.com/"
pdf_test="file - | grep -q 'PDF document'"
github_test="grep -q Redirecting.*https://github.com/aflury/flurydotorg"
call_test="grep -q tel:[0-9\+]"
text_test="grep -q sms:[0-9\+]"

tests[call]=$call_test
tests[chat]=$linkedin_test
tests[cv]=$pdf_test
tests[linkedin]=$linkedin_test
tests[message]=$linkedin_test
tests[resume]=$pdf_test
tests[source]=$github_test
tests[text]=$text_test
tests[xn--rsum-bpad]=$pdf_test

for subdomain in "${!tests[@]}"
do
  echo
  echo "Running '$subdomain' test..."
  if ( set -x && curl -s https://$subdomain.$DOMAIN | eval ${tests[$subdomain]} )
  then
    set +x
    echo 'OK'
  else
    set +x
    echo 'FAILED!'
    failed=1
  fi
done

if [ "$failed" = "1" ]
then
  echo
  which banner > /dev/null && banner -w 60 fail
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
