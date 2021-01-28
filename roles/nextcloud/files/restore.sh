#!/bin/bash
set -e

# Find and verify backup directory
LOCATION="$1"
if [ "$LOCATION" == "" ]; then
    LOCATION="/var/backup/ncbackup"
fi
if ! [ -d "$LOCATION" ]; then
   echo "No backup at $LOCATION"
   exit 1
fi
if ! [ -f "$LOCATION/dbdump" ]; then
    echo "No database dump, refusing to restore"
    exit 1
fi

echo "Restoring from $LOCATION"

# Maintenance on
/usr/bin/runuser -u http -- /usr/bin/php /usr/share/webapps/nextcloud/occ maintenance:mode --on

# Restore files
rsync -avx $LOCATION/folders/{apps,apps2,data,themes} /usr/share/webapps/nextcloud

# Restore db dump to clean db
cd /
/usr/bin/runuser -u postgres -- psql -c "DROP DATABASE \"nextcloud\";"
/usr/bin/runuser -u postgres -- psql -c "CREATE DATABASE \"nextcloud\";"
cp "$LOCATION/dbdump" /var/lib/postgres/
chown postgres:postgres /var/lib/postgres/dbdump
/usr/bin/runuser -u postgres -- pg_restore -d nextcloud /var/lib/postgres/dbdump
rm /var/lib/postgres/dbdump

# Re-add inidices
/usr/bin/runuser -u http -- /usr/bin/php /usr/share/webapps/nextcloud/occ db:add-missing-indices

# Maintenance off
/usr/bin/runuser -u http -- /usr/bin/php /usr/share/webapps/nextcloud/occ maintenance:mode --off
