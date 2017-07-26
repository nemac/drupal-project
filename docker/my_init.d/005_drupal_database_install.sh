#!/usr/bin/env bash
#
# This script is run when the container is first started.
#
# Checks if there are tables in the database, if not attempts to restore the most recent committed dump.
#

source /etc/container_environment.sh

# If the database is not empty, skip.
tableCount=$(drush sql-query "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=\"${DRUPAL_DB_NAME}\";"  )
if [[ ! "0" = "${tableCount}" ]]; then
  echo "Database is not empty. Skipping automated import."
  exit 0
fi

# find the most recent dump (if any) and import it.
mostRecentBackup=`find /app/sql/dump_*.sql -maxdepth 1 -type f | sort -r | head -1`
if [[ ! -z "$mostRecentBackup" && -f "$mostRecentBackup" ]]; then
  echo "found database backup, restoring.."
  drush sql-cli < "${mostRecentBackup}"
  if [[ "${?}" != "0" ]]; then
    echo "There may have been a problem importing database! Proceed with caution!"
  else
    echo "Database imported!"
  fi
fi