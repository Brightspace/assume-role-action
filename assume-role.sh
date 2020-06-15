#!/bin/sh

# Set environment variables based on the output of aws sts assume-role
# https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-an-environment-variable

echo "Acquiring temporary tokens for the role ${0}"

aws sts assume-role --role-arn "${0}" --role-session-name github-actions | \
jq -r '.Credentials | "::set-env name=AWS_ACCESS_KEY_ID::\(.AccessKeyId)\n::set-env name=AWS_SECRET_ACCESS_KEY::\(.SecretAccessKey)\n::
set-env name=AWS_SESSION_TOKEN::\(.SessionToken)"'
