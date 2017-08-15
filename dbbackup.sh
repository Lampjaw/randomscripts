#! /bin/bash

BACKUP_DIR="/mnt/backup/database/$(date +'%F')"

MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump

source scriptlogger.sh -p "$BACKUP_DIR" -f "backup.log"

mkdir -p "$BACKUP_DIR"

databases=`$MYSQL -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|sys|mysql)"`

echo "Backing up databases"

for db in $databases; do
    echo "Beginning dump for database '$db'"
    $MYSQLDUMP --force --create-options --disable-keys --extended-insert --quick --databases $db | gzip > "$BACKUP_DIR/$db.sql.gz"
    echo "Database '$db' dump complete"
done
