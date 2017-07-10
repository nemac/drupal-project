#!/usr/bin/env bash
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$DIR" = "/usr/lcoal/bin" ]]; then
DIR="/app/scripts"
fi

PROJECT_DIR="$(cd "${DIR}/.." && pwd)"

if [[ -z $1 ]]; then
echo "Usage: sql-import File"
echo "File path is relative to project dir. File extension must be .sql"
exit 1
fi

if [[ !"${1:-3}" == "sql" ]]; then
echo "Invalid file extension. Must be .sql"
exit 1
fi
file=${PROJECT_DIR}/${1}
if [[ !-f "${file}" ]]; then
 echo "File not found."
 exit 1
fi

read -p "This will overwrite the contents of the database with the contents of $1! You should probably make a backup before proceeding. Are you sure? [y/n]" -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  $DIR/drush.sh sql-drop -y && $DIR/drush.sh sql-cli < "${file}"
fi


