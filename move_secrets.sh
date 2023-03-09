#!/bin/bash

# Set the source and destination project IDs
SOURCE_PROJECT="american-xpress"
DESTINATION_PROJECT="global-matrix-374023"
# Authenticate with gcloud
# gcloud auth login
# Fetch the list of secrets from the source project
# SECRET_LIST=$(gcloud secrets list --project ${SOURCE_PROJECT} --format="value(name)")

declare -a SECRET_LIST=("test_a" "test_b" "test_c" "test_d")

# for i in "${SECRET_LIST[@]}"
for i in "${SECRET_LIST[@]}"
do
    SECRET_NAME="${i}"
    SECRET_VALUE=$(gcloud secrets versions access "latest" --secret=${SECRET_NAME})
    echo $SECRET_VALUE > secret_migrate

    if gcloud secrets describe ${SECRET_NAME} --project=${DESTINATION_PROJECT} >/dev/null 2>&1; then
     echo "The secret ${SECRET_NAME} already exists in project ${DESTINATION_PROJECT}. Moving to the next secret..."
    continue
  fi

    $(gcloud secrets create ${SECRET_NAME} --project=$DESTINATION_PROJECT --data-file=secret_migrate)
done
rm secret_migrate