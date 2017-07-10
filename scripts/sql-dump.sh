#!/usr/bin/env bash
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$DIR" = "/usr/local/bin" ]]; then
DIR="/app/scripts"
fi

backupFile="/app/sql/dump_$(date +'%Y-%m-%d_%H%M').sql"
set -x

$DIR/drush.sh sql-dump --result-file="${backupFile}" --ordered-dump --extra=--single-transaction --extra=--quick
