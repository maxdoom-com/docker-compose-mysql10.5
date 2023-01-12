#!/bin/sh


####################################################################
## CREATE A USER AND A GROUP WITH YOUR IDS
####################################################################

addgroup -g ${GID} you
adduser -D -h /home/you -u ${UID} -G you -s /bin/bash you


####################################################################
## DIRS AND PERMISSION
####################################################################

mkdir -p /run/mysqld
chown -R you:you /run/mysqld

mkdir -p /var/lib/mysql
chown -R you:you /var/lib/mysql


####################################################################
# install mysql
####################################################################

mysql_install_db --user=you --ldata=/var/lib/mysql


####################################################################
# DATABASE SETUP
####################################################################

tmp=`mktemp`
cat << __EOF__ > $tmp
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET ${MYSQL_CHARSET} COLLATE ${MYSQL_COLLATION};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES ;
__EOF__



####################################################################
## CREATING THE USER AND SETTING THE PASSWORDS
####################################################################

/usr/bin/mysqld --user=you --bootstrap --verbose=1 --skip-name-resolve --skip-networking=0 < $tmp
rm -f $tmp


####################################################################
## RUNNING IT
####################################################################

/usr/bin/mysqld --user=you --skip-networking=0


####################################################################
## SLEEP ENDLESS
####################################################################

sleep infinity
