#!/bin/bash
set -euo pipefail
echo "===== Salesforces CI Validate (checkOnly) ====="
if [ -z "${SF_AUTH_URL:-}" ]; then
echo "SF_AUTH_URL is not set. Export it or set it in environment."
exit 2
fi
echo "$SF_AUTH_URL" > sfdx_auth.txt
sfdx auth:sfdxurl:store -f sfdx_auth.txt -a ci_org
rm sfdx_auth.txt
echo "Running check-only deploy (no changes saved)"
sfdx force:source:deploy -p force-app --targetusername ci_org --checkonly --wait 10
echo "Running local tests (RunLocalTests)"
sfdx force:apex:test:run --targetusername ci_org --resultformat human --wait 10 --codecoverage
echo "Validation complete."
