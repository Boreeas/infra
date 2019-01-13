Setup a nextcloud instance. A backup and a restore script are put into /etc/webapps/nextcloud
and the backup script is scheduled to run daily.

If a clean install is wanted after a previous installation, pass
nextcloud_purge_install_yes_really (`--extra-vars nextcloud_purge_install_yes_really=true`).
The backups are not affected by the purge.

After an installation, executing the restore script restores the backup. The installation
should be clean for this to work.
