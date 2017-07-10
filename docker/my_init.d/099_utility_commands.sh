#!/usr/bin/env bash

ln -sf /app/scripts/drush.sh /usr/local/bin/drush
ln -sf /app/scripts/sql-dump.sh /usr/local/bin/sql-dump
ln -sf /app/scripts/sql-import.sh /usr/local/bin/sql-import
echo -e "
Utility commands:
  drush
  composer
  sql-dump - Runs \\\`drush sql-dump\\\`
  sql-import - Imports sql dump from file using drush.
" >> "/etc/bash.bashrc";