#!/usr/bin/env bash

# This script cleans up:
# - docker volumes associated with this project (including the drupal database)
# - /vendor files from composer
# - composer.lock
# - all files under /web (Drupal 8 only, these files should be kept in Drupal 7)
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"${DIR}/drun.sh" down -v

cd $DIR/../
rm -rf "vendor"
rm -f "composer.lock"
rm -rf "web"
