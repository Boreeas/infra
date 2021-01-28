#!/bin/bash
set -e

# Find backup location
LOCATION="$1"
if [ "$LOCATION" == "" ]; then
    LOCATION="/var/backup/ncbackup"
fi

echo "Backing up to $LOCATION"
mkdir -p "$LOCATION"

# Maintenance on
/usr/bin/runuser -u http -- /usr/bin/php /usr/share/webapps/nextcloud/occ maintenance:mode --on

# Dump database
/usr/bin/runuser -u postgres -- pg_dump -F custom nextcloud > "$LOCATION/dbdump"

# Copy files
rsync -avx /usr/share/webapps/nextcloud/{apps,apps2,data,themes} $LOCATION/folders/

# Maintenance on
/usr/bin/runuser -u http -- /usr/bin/php /usr/share/webapps/nextcloud/occ maintenance:mode --off
