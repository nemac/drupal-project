#!/usr/bin/env bash

cat >> "/etc/bash.bashrc" <<- EOM
echo -e "
Utility commands:
  drush
  composer
  sql-dump - Runs \\\`drush sql-dump\\\`
  sql-import - Imports sql dump from file using drush.
  a2ensite - Enable apache vhost
  a2dissite - Disable apache vhost
  a2enconf - Enable apache config file
  a2disconf - Disable apache config file
"
EOM

ln -sf /app/scripts/drush.sh /usr/local/bin/drush
ln -sf /app/scripts/sql-dump.sh /usr/local/bin/sql-dump
ln -sf /app/scripts/sql-import.sh /usr/local/bin/sql-import

# The helper scripts below have been included in this file to reduce clutter, but could be moved elsewhere just as easily.

cat > /usr/bin/a2ensite <<- EOM
  #!bin/bash
  # Enable a site, just like the a2ensite command from Apache2 on Debian/Ubuntu.

  SITES_AVAILABLE_CONFIG_DIR="/etc/httpd/sites-available";
  SITES_ENABLED_CONFIG_DIR="/etc/httpd/sites-enabled";

  if [[ \$# -eq 0 ]]; then
   echo -e "Usage: a2ensite site\nSites currently enabled: "
    for f in \${SITES_ENABLED_CONFIG_DIR}/*.conf; do
      printf '  %s\n' "\${f%.conf}"
    done
    echo "Sites available:"
    for f in \${SITES_AVAILABLE_CONFIG_DIR}/*.conf; do
      printf '  %s\n' "\${f%.conf}"
    done
    exit 0;
  fi

  for c in "\${@}"; do
    if [ -f "\${SITES_ENABLED_CONFIG_DIR}/\${c}.conf" ]; then
      echo "Site \${c} was already enabled!";
    elif [ ! -w \$SITES_ENABLED_CONFIG_DIR ]; then
      echo "You don't have permission to do this. Try to run the command as root."
    elif [ -f "\${SITES_AVAILABLE_CONFIG_DIR}/\${c}.conf" ]; then
      echo "Enabling site \${c}...";
      ln -s \$SITES_AVAILABLE_CONFIG_DIR/\$c.conf \$SITES_ENABLED_CONFIG_DIR/\$c.conf
      echo "done!"
    else
     echo "Site \${c} not found!"
    fi
  done
EOM

cat > /usr/bin/a2dissite <<- EOM
  #!bin/bash
  # Disable a site, just like the a2dissite command from Apache2 on Debian/Ubuntu.

  SITES_AVAILABLE_CONFIG_DIR="/etc/httpd/sites-available";
  SITES_ENABLED_CONFIG_DIR="/etc/httpd/sites-enabled";
  
  if [[ \$# -eq 0 ]]; then
      echo -e "Usage: a2dissite site\nSites currently enabled: "
      for f in \${SITES_ENABLED_CONFIG_DIR}/*.conf; do
        printf '  %s\n' "\${f%.conf}"
      done
      exit 0;
  fi

  for c in "\${@}"; do
    if [ ! -f "\${SITES_ENABLED_CONFIG_DIR}/\${c}.conf" ]; then
      echo "Site \${c} was already disabled!";
    elif [ ! -w \$SITES_ENABLED_CONFIG_DIR ]; then
      echo "You don't have permission to do this. Try to run the command as root."
    elif [ -f "\${SITES_AVAILABLE_CONFIG_DIR}/\${c}.conf" ]; then
      echo "Disabling site \${c}...";
      unlink \$SITES_ENABLED_CONFIG_DIR/\$c.conf
      echo "done!"
    else
      echo "Site \${c} not found!"
    fi
  done
EOM

cat > /usr/bin/a2enconf <<- EOM
  #!bin/bash
  # Enable an apache conf file, just like the a2disconf command from Apache2 on Debian/Ubuntu.

  CONF_AVAILABLE_CONFIG_DIR="/etc/httpd/conf-available";
  CONF_ENABLED_CONFIG_DIR="/etc/httpd/conf-enabled";

  if [[ \$# -eq 0 ]]; then
    echo -e "Usage: a2enconf conf\nConfs currently enabled: "
    for f in \${CONF_ENABLED_CONFIG_DIR}/*.conf; do
      printf '  %s\n' "\${f%.conf}"
    done
    echo "Confs available:"
    for f in \${CONF_AVAILABLE_CONFIG_DIR}/*.conf; do
      printf '  %s\n' "\${f%.conf}"
    done
    exit 0;
  fi
  for c in "\${@}"; do
    if [ -f "\${CONF_ENABLED_CONFIG_DIR}/\${c}.conf" ]; then
      echo "Conf \${c} was already enabled!";
    elif [ ! -w \$CONF_ENABLED_CONFIG_DIR ]; then
      echo "You don't haveI permission to do this. Try to run the command as root."
    elif [ -f "\${CONF_AVAILABLE_CONFIG_DIR}/\${c}.conf" ]; then
      echo "Enabling conf \${c}...";
      ln -s \$CONF_AVAILABLE_CONFIG_DIR/\$c.conf \$CONF_ENABLED_CONFIG_DIR/\$c.conf
      echo "done!"
    else
     echo "Conf \${c} not found!"
    fi
  done
EOM

cat > /usr/bin/a2disconf <<- EOM
  #!bin/bash
  # Disable an apache conf file, just like the a2disconf command from Apache2 on Debian/Ubuntu.

  CONF_AVAILABLE_CONFIG_DIR="/etc/httpd/conf-available";
  CONF_ENABLED_CONFIG_DIR="/etc/httpd/conf-enabled";
  
  if [[ \$# -eq 0 ]]; then
    echo -e "Usage: a2disconf conf\nConfs currently enabled:"
    for f in \${CONF_ENABLED_CONFIG_DIR}/*.conf; do
      printf '  \n%s' "\${f%.conf}"
    done
    exit 0;
  fi

  for c in "\${@}"; do
    if [ ! -f "\${CONF_ENABLED_CONFIG_DIR}/\${c}.conf" ]; then
      echo "Conf \${c} was already disabled!";
    elif [ ! -w \$CONF_ENABLED_CONFIG_DIR ]; then
      echo "You don't have permission to do this. Try to run the command as root."
    elif [ -f "\${CONF_AVAILABLE_CONFIG_DIR}/\${c}.conf" ]; then
      echo "Disabling conf \${c}...";
      unlink \$CONF_ENABLED_CONFIG_DIR/\$c.conf
      echo "done!"
    else
      echo "Conf \${c} not found!"
    fi
  done
EOM

chmod +x /usr/bin/a2*


