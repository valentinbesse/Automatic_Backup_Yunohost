#!/bin/bash

BACKUP_FOLDER=/home/yunohost.backup/archives
SYNCTHING_BACKUP_FOLDER="/home/yunohost.app/syncthing/Aumbox - Backup"
EXPIRY=7
USER_SPECIFIC=syncthing
GROUP_SPECIFIC=syncthing

# Remove tar files in $SYNCTHING_BACKUP_FOLDER older tab than $EXPIRY (day)
find "$SYNCTHING_BACKUP_FOLDER" -name "*.tar" -type f -mtime +$EXPIRY -exec rm -f {} \;
find "$SYNCTHING_BACKUP_FOLDER" -name "*.json" -type f -mtime +$EXPIRY -exec rm -f {} \;

# Remove tar files in $BACKUP_FOLDER older tab than $EXPIRY (day)
find $BACKUP_FOLDER -name "*.tar" -type f -mtime +$EXPIRY -exec rm -f {} \;
find $BACKUP_FOLDER -name "*.json" -type f -mtime +$EXPIRY -exec rm -f {} \;

# Create backup
yunohost backup create --system --apps baikal bitwarden rainloop ttrss

# Copy backup from $BACKUP_FOLDER to $SYNCTHING_BACKUP_FOLDER
find $BACKUP_FOLDER -name "*.tar" -type f -mtime -1 -exec cp {} "$SYNCTHING_BACKUP_FOLDER"/ \;
find $BACKUP_FOLDER -name "*.json" -type f -mtime -1 -exec cp {} "$SYNCTHING_BACKUP_FOLDER"/ \;

# Give specific user the ownership of the file
find "$SYNCTHING_BACKUP_FOLDER" -name "*.tar" -exec chown $USER_SPECIFIC:$GROUP_SPECIFIC {} \;
find "$SYNCTHING_BACKUP_FOLDER" -name "*.json" -exec chown $USER_SPECIFIC:$GROUP_SPECIFIC {} \;