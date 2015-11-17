#!/bin/sh

# Use the TZ environment variable, otherwise use UTC
PHP_TIMEZONE="UTC"
if [ -n "${TZ}" ]
then
    PHP_TIMEZONE="$TZ"
fi

find /etc/php5 -name php.ini -print0 | xargs -0 sed -i "s#;date.timezone =.*#date.timezone = $PHP_TIMEZONE#"

if [ ! -z "$DEBUG" ]
then
    php5enmod xdebug
    sed -i 's#^display_errors = Off#display_errors = On#' /etc/php5/fpm/php.ini
fi



# Pull down code form git for our site!
if [ ! -z "$GIT_REPO" ]; then
  if [ ! -z "$GIT_BRANCH" ]; then
    git clone -b $GIT_BRANCH $GIT_REPO /data
  else
    git clone $GIT_REPO /data
  fi
  if [ ! -z "$GIT_CHECKOUT_COMMIT" ]; then
    cd /data
    git checkout $GIT_CHECKOUT_COMMIT
  fi
  chown -Rf www-data /data
fi

echo "use auth: $USE_AUTH"
if [ ! -z "$USE_AUTH" ]; then
  sed -i 's#\#auth_code#auth_basic "Restricted area"; auth_basic_user_file /etc/nginx/htpasswd;#' /etc/nginx/sites-available/default

  echo "user: $AUTH_USER pass: $AUTH_PASS"
  htpasswd -b -c /etc/nginx/htpasswd "$AUTH_USER" "$AUTH_PASS"
  cat /etc/nginx/htpasswd
fi
