#!/usr/bin/env bash
#
# This script is run when the container is first started.
#
source /etc/container_environment.sh

# If the database is not empty, skip.
cd /app/web
tableCount=$(/app/vendor/bin/drush sql-query "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=\"${DRUPAL_DB_NAME}\";")
if [[ ! "0" = "${tableCount}" ]]; then
echo "Database is not empty. Skipping automated import."
exit 0;
fi

# find the most recent dump (if any) and import it.
mostRecentBackup=`find /app/sql/dump_*.sql -maxdepth 1 -type f | sort -r | head -1`
  if [[ ! -z "$mostRecentBackup" && -f "$mostRecentBackup" ]]; then
    echo "found database backup, restoring.."
    /app/vendor/bin/drush sql-cli < "${mostRecentBackup}"
    if [[ "${?}" != "0" ]]; then
      echo "There may have been a problem importing database! Proceed with caution!"
    else
      echo "Database imported!"
    fi
  fi