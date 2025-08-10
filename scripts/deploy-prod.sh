#!/bin/bash
set -euo pipefail
echo "===== Salesforces Production Deploy ====="
if [ -z "${SF_PROD_AUTH_URL:-}" ]; then
echo "SF_PROD_AUTH_URL is not set. Export it or set it in environment."
exit 2
fi
echo "$SF_PROD_AUTH_URL" > sfdx_prod_auth.txt
sfdx auth:sfdxurl:store -f sfdx_prod_auth.txt -a prod_org
rm sfdx_prod_auth.txt
echo "Deploying to production and running local tests"
sfdx force:source:deploy -p force-app --targetusername prod_org --testlevel RunLocalTests --wait 20
echo "Production deploy finished."