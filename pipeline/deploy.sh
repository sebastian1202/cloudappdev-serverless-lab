#!/bin/bash
set -x #echo on

REGION_CODE="${PROD_REGION_ID//ibm:yp:/}"
bx login --apikey ${DEPLOYER_API_KEY} -a https://api.${REGION_CODE}.bluemix.net -o ${PROD_ORG_NAME} -s ${PROD_SPACE_NAME}


# creating the first action
./pipeline/create-action.sh prepare-entry-for-save prepare-entry-for-save.js 

# creating the second action
./pipeline/create-action.sh set-read-input set-read-input.js 

# creating the third action
./pipeline/create-action.sh format-entries format-entries.js 

# creating sequences

./pipeline/create-action.sh save-feedback-entry-sequence prepare-entry-for-save,fa-functions-db/create-document --sequence --web true

./pipeline/create-action.sh save-feedback-entry-sequence set-read-input,fa-functions-db/list-documents,format-entries --sequence --web true

# create APIs

bx fn api create /feedback /entries GET read-feedback-entries-sequence

bx fn api create /feedback /entries POST save-feedback-entry-sequence
