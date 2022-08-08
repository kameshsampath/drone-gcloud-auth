#!/usr/bin/env bash

set -e
set -o pipefail

set -x 

RELEASE_PLEASE_COMMAND=release-please

if [ -n "${PLUGIN_RELEASE_PLEASE_COMMAND}" ];
then
  RELEASE_PLEASE_COMMAND_ARGS+=("${PLUGIN_RELEASE_PLEASE_COMMAND}")
else
  RELEASE_PLEASE_COMMAND_ARGS+=("release-pr")
fi

if [ -z "${PLUGIN_TOKEN}" ];
then
  echo "Please provide the Git repository token with write permissions"
	exit 1
fi

RELEASE_PLEASE_COMMAND_ARGS+=("--token=${PLUGIN_TOKEN}")

REPO_URL=${PLUGIN_REPO_URL:-"${DRONE_REPO}"}
if [ -z "${REPO_URL}" ];
then
  echo "Please provide the Git repository url in <owner>/<repo> format token with write permissions"
	exit 1
fi
RELEASE_PLEASE_COMMAND_ARGS+=("--repo-url=${REPO_URL}")

if [ -n "${PLUGIN_API_URL}" ];
then
	RELEASE_PLEASE_COMMAND_ARGS+=("--api-url=${PLUGIN_API_URL}")
fi

if [ -n "${PLUGIN_GRAPHQL_URL}" ];
then
	RELEASE_PLEASE_COMMAND_ARGS+=("--graphql-url=${PLUGIN_GRAPHQL_URL}")
fi

if [ -n "${PLUGIN_TARGET_BRANCH}" ];
then
	RELEASE_PLEASE_COMMAND_ARGS+=("--target-branch=${PLUGIN_TARGET_BRANCH}")
fi

if [ -n "${PLUGIN_DRY_RUN}" ];
then
	RELEASE_PLEASE_COMMAND_ARGS+=("--dry-run=true")
fi

if [ -n "${PLUGIN_DEBUG}" ];
then
	RELEASE_PLEASE_COMMAND_ARGS+=("--debug=true")
fi

if [ -n "${PLUGIN_TRACE}" ];
then
	RELEASE_PLEASE_COMMAND_ARGS+=("--trace=true")
fi

if [ -n "${PLUGIN_EXTRA_OPTIONS}" ];
then
  OLDIFS=$IFS
  IFS=', ' read -r -a extra_opts <<< "$PLUGIN_EXTRA_OPTIONS"
  RELEASE_PLEASE_COMMAND_ARGS+=("${extra_opts[@]}")
  IFS="$OLDIFS"
fi

# printf "Running command release-please %s" "${RELEASE_PLEASE_COMMAND_ARGS[*]}"

exec bash -c "${RELEASE_PLEASE_COMMAND} ${RELEASE_PLEASE_COMMAND_ARGS[*]}"