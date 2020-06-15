#!/bin/sh

set -euo pipefail

# Set environment variables based on the output of aws sts assume-role
# https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-an-environment-variable

echo "Acquiring temporary tokens for the role ${1}"

aws sts assume-role --role-arn "${1}" --role-session-name github-actions > sts.json

cat /env-var-names.json | jq -r 'to_entries | map([
  "::add-mask::" + $sts[0].Credentials[.value],
  "::set-env name=" + .key + "::" + $sts[0].Credentials[.value]
]) | flatten | .[]' --slurpfile sts sts.json

rm sts.json
