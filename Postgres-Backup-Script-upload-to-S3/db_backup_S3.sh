#!/bin/bash

# Set PostgreSQL connection parameters
PG_HOST="localhost"          # PostgreSQL server address
PG_PORT="5432"               # PostgreSQL port
PG_USER="postgres"       # PostgreSQL user with access to all databases
PG_PASSWORD="spqaqyeZ2RL0c03G"  # PostgreSQL password (optional, can be set in PGPASSWORD env var)
S3_BUCKET="s3://database-backups"  # S3 bucket where backups will be uploaded

# Optional: Set a specific backup directory on local machine
BACKUP_DIR="/opt/backup/postgres-db-backups"

# Export the password for PostgreSQL access
export PGPASSWORD=$PG_PASSWORD


# Create the main backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Loop over all databases except templates
databases=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

# Iterate through each database
for db in $databases; do
    echo "Backing up database: $db"

    # Create a subdirectory for each database within the main backup directory
    DB_BACKUP_DIR="$BACKUP_DIR/$db"
    mkdir -p "$DB_BACKUP_DIR"

    # Define backup file name inside the database-specific directory
    BACKUP_FILE="$DB_BACKUP_DIR/$db-$(date +%F_%H-%M-%S).sql.gz"

    # Perform the backup and compress it using gzip
    pg_dump -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -F c "$db" | gzip > "$BACKUP_FILE"

    # Check if the backup was successful
    if [ $? -eq 0 ]; then
        echo "Backup of $db completed successfully."

        # Upload the compressed backup file to S3
        aws s3 cp "$BACKUP_FILE" "$S3_BUCKET/$db/$(basename "$BACKUP_FILE")"

        # Check if the upload was successful
        if [ $? -eq 0 ]; then
            echo "Backup for $db uploaded to S3 successfully."
            # Optionally remove the local backup file after successful upload
            #rm "$BACKUP_FILE"
        else
            echo "Failed to upload $db backup to S3."
        fi
    else
        echo "Backup of $db failed."
    fi
done


echo "Backup process completed."
