#!/usr/bin/env bash

set -e
set -o pipefail

if [ -z "${PLUGIN_GOOGLE_APPLICATION_CREDENTIALS}" ];
then
	echo "Please provide Google Service Account JSON to use."
	exit 1
fi

if [ -n "${PLUGIN_GOOGLE_CLOUD_PROJECT}" ];
then
	echo "Please provide Google Cloud Project to use."
fi


echo "$PLUGIN_GOOGLE_APPLICATION_CREDENTIALS" > "$HOME/sa.json"
chmod 0600 "$HOME/sa.json"

gcloud auth login --cred-file="$HOME/sa.json" --activate

gcloud config set core/project "${PLUGIN_GOOGLE_CLOUD_PROJECT}"

if [ -n "${PLUGIN_GOOGLE_CLOUD_REGION}" ];
then
	gcloud config set compute/region "${PLUGIN_GOOGLE_CLOUD_REGION}"
fi

if [ -z "${PLUGIN_REGISTRIES}" ];
then
   gcloud auth -q configure-docker gcr.io
else
   gcloud auth -q configure-docker "${PLUGIN_REGISTRIES}"
fi
