#!/usr/bin/env bash
#
# This script is run when the container is first started.
#

set -x

#Download secrets and run certbot.
if [[ ! -z "$SECRETS_STORE" ]]; then
 echo "No SECRETS_STORE. Skipping HTTPS."
 exit 0
fi

aws s3 sync ${SECRETS_STORE} /secrets;

if [[ ! "$ENABLE_HTTPS" = true ]]; then
echo "HTTPS is disabled. Skipping config."
exit 0;
fi

# Rebuild letsencrypt symlinks
mkdir -p /secrets/letsencrypt
certIndex=1
for f in "/secrets/letsencrypt/archive/${PRIMARY_DOMAIN}/cert*.pem"; do
  if [[ ${f:4:-4} > $certIndex ]]; then
    $certIndex = ${f:4:-4}
  fi
done
for f in "cert" "fullchain" "chain" "privkey"; do
  if [[ -e /secrets/letsencrypt/archive/${PRIMARY_DOMAIN}/${f}${certIndex}.pem ]]; then
    ln -s /secrets/letsencrypt/archive/${PRIMARY_DOMAIN}/${f}${certIndex}.pem /secrets/letsencrypt/live/${PRIMARY_DOMAIN}/${f}.pem;
  fi
done
# Build list of cnames that should also be registered
cnames=""
ALTERNATE_DOMAINS=${ALTERNATE_DOMAINS// /}
for cname in ${ALTERNATE_DOMAINS//,/ }; do
cnames="$cnames -d $cname"
done

# Run certbot, get cert only, non-interactive mode, use apache for challenge, keep existing certs if they have not yet expired, don't fail entirely if some domains don't work
certbot certonly -n --apache --keep --allow-subset-of-names -d ${PRIMARY_DOMAIN} ${cnames} --email ${ADMIN_EMAIL} --agree-tos \
  && aws s3 sync /secrets ${SECRETS_STORE} --no-follow-symlinks

echo "52 0,12 * * * root certbot renew -n && aws s3 sync /secrets ${SECRETS_STORE} --no-follow-symlinks" > /etc/cron.d/certbot