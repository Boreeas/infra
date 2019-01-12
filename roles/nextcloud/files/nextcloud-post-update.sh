/usr/bin/runuser -u http -- /usr/bin/php /usr/share/webapps/nextcloud/occ upgrade
chown http:http /usr/share/webapps/nextcloud/.htaccess
/usr/bin/runuser -u http -- /usr/bin/php /usr/share/webapps/nextcloud/occ maintenance:update:htaccess
/usr/bin/runuser -u http -- /usr/bin/php /usr/share/webapps/nextcloud/occ maintenance:mode --off
