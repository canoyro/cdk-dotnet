#!/usr/bin/env bash
set -euo pipefail

stack_name="${STACK_NAME:-CdkDotnetStack}"
environment_name="${ENVIRONMENT_NAME:-${Octopus_Environment_Name:-dev}}"

if [[ -n "${AWS_REGION:-}" ]]; then
  export AWS_REGION
fi

npm ci
npx cdk deploy "$stack_name" \
  --require-approval never \
  --context "environment=$environment_name"
