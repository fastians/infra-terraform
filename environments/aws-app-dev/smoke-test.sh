#!/usr/bin/env bash
# First smoke test: AWS credentials + Seoul region API (before terraform plan/apply).
# Always uses ap-northeast-2 for STS so ~/.aws/config values like "seoul" cannot break this script.
set -euo pipefail

REGION="${AWS_REGION:-ap-northeast-2}"

echo "=== AWS smoke test (region: ${REGION}) ==="
if ! command -v aws >/dev/null 2>&1; then
  echo "error: aws CLI not found. Install it and run aws configure." >&2
  exit 1
fi

aws sts get-caller-identity --region "${REGION}" --output json
echo "ok: caller identity succeeded"

aws ec2 describe-availability-zones --region "${REGION}" \
  --filters Name=state,Values=available \
  --query 'AvailabilityZones[].ZoneName' --output text >/dev/null
echo "ok: EC2 API reachable in ${REGION}"
