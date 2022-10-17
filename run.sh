#!/usr/bin/env bash

set -eo pipefail

if [ -z "${PLUGIN_GOOGLE_APPLICATION_CREDENTIALS}" ];
then
	echo "Please provide Google Service Account JSON to use."
	exit 1
fi

if [ -z "${PLUGIN_GOOGLE_CLOUD_PROJECT}" ];
then
	echo "Please provide Google Cloud Project to use."
  exit 1
fi

echo "$PLUGIN_GOOGLE_APPLICATION_CREDENTIALS" > "$HOME/sa.json"
chmod 0600 "$HOME/sa.json"

gcloud auth login --cred-file="$HOME/sa.json" --activate

gcloud config set core/project "${PLUGIN_GOOGLE_CLOUD_PROJECT}"

if [ -n "${PLUGIN_GOOGLE_CLOUD_REGION}" ];
then
	gcloud config set compute/region "${PLUGIN_GOOGLE_CLOUD_REGION}"
  gcloud auth -q configure-docker "$PLUGIN_GOOGLE_CLOUD_REGION-docker.pkg.dev"
fi

if [ -n "${PLUGIN_REGISTRY_LOCATIONS}" ];
then
   GAR_LOCATIONS="$(echo -n "$PLUGIN_REGISTRY_LOCATIONS" | sed 's|,|-docker.pkg.dev,|')-docker.pkg.dev"
   gcloud auth -q configure-docker "${GAR_LOCATIONS}"
fi
