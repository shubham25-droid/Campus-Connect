#!/bin/sh
set -e

# Support dynamic PORT environment variable provided by Render or cloud hosts
PORT="${PORT:-8080}"
echo "[CampusConnect] Binding Tomcat HTTP port to: $PORT"

if [ -f /usr/local/tomcat/conf/server.xml ]; then
    sed -i "s/port=\"8080\"/port=\"$PORT\"/g" /usr/local/tomcat/conf/server.xml
fi

exec catalina.sh run
