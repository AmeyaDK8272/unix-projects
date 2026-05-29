#!/bin/bash

SOURCE="/home/akulkarni/mydata"
BACKUP_DIR="/home/akulkarni/backups"
LOG_FILE="/home/akulkarni/backup-tool/backup.log"
MAX_BACKUPS=5

mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

log()
{
 echo "$(date +"%Y-%m-%d %H:%M:%S") $1" | tee -a $LOG_FILE
}

if [ ! -d "$SOURCE" ]
then
     log "ERROR: Source folder $SOURCE not found!"
     exit 1
fi

FREE_SPACE=$(df -m $BACKUP_DIR | awk "NR==2 {print \$4}")
SOURCE_SIZE=$(du -sm $SOURCE | awk "{print \$1}")

if [ "$FREE_SPACE" -lt "$SOURCE_SIZE" ]
then
    log "ERROR: Not enough disk space!"
    exit 1
fi

log "INFO: Starting backup of $SOURCE"
log "INFO: Source Size: ${SOURCE_SIZE}MB"
log "INFO: Free Space: ${FREE_SPACE}MB"

tar -czf $BACKUP_FILE $SOURCE 2>/dev/null

if [ -f "$BACKUP_FILE" ]
then
    log "INFO: Backup successful -> $BACKUP_FILE"
else
    log "ERROR: Backup failed!"
exit 1
fi

BACKUP_COUNT=$(ls $BACKUP_DIR/backup_*.tar.gz | wc -l)
log "INFO: Total backups: $BACKUP_COUNT (max allowed: $MAX_BACKUPS)"

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]
then
    log "INFO: Rotating old backups..."
    ls -t $BACKUP_DIR/backup_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | while read OLD_BACKUP
    do
       rm -f $OLD_BACKUP
       log "INFO: Deleted old backup -> $OLD_BACKUP"
    done
fi

FINAL_SIZE=$(du -sh $BACKUP_FILE | awk "{print \$1}")
log "INFO: Backup size: $FINAL_SIZE"
log "INFO: Backup complete!"
log "-------------------------------------------------------"
