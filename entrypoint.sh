#!/bin/sh

# Ensure the script is called with the handler name
if [ $# -ne 1 ]; then
  echo "entrypoint requires the handler name to be the first argument" 1>&2
  exit 142
fi
export _HANDLER="$1"

# Define the Lambda runtime entry point

RUNTIME_ENTRYPOINT=/var/runtime/bootstrap

# Check if running within the AWS Lambda environment or using RIE
if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
  exec /usr/local/bin/aws-lambda-rie $RUNTIME_ENTRYPOINT
else
  exec $RUNTIME_ENTRYPOINT
fi
