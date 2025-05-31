#!/usr/bin/env bash

mysql -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD hvac < /tmp/hvac.sql

if [ $? -eq 0 ]; then
	echo "db has been set up"
else
	echo "db set up failed"
fi