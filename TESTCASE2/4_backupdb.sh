#!/bin/bash

########################################################################
# 4. Create script backup database, compress the db and retain 30 days #
########################################################################


# CONFIGURATIONS
BACKUP_DIR="path_to_backup_dir"		# Backup Directory
DB_USER="db_user"			# Username for DB
DB_PASSWORD="db_password"		# Password for DB
DB_NAME="db_name"			# The DB name we want to backup
RETENTION_DAYS=30			# DB backup retention

# Date for file name
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Backup file name
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_backup_${DATE}.sql.gz"

# Create backup directory if not exist
mkdir -p "$BACKUP_DIR"

# Backup & commpress DB
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" | gzip > "$BACKUP_FILE"

# Check if backup success / failed
if [ $? -eq 0 ]; then
    echo "Backup success: $BACKUP_FILE"
else
    echo "Backup FAILED!"
    exit 1
fi

# Delete backup file longer than 30 days
find "$BACKUP_DIR" -type f -name "${DB_NAME}_backup_*.sql.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;

# Delete notification
if [ $? -eq 0 ]; then
    echo "Backup file longer than $RETENTION_DAYS days has been deleted."
else
    echo "There are no backup older than 30 days."
    exit 1
fi
