# WordPress Site Migration Script
WordPress full migration script for backups created at Hostinger

## Overview

This bash script facilitates the migration of WordPress sites hosted on Hostinger. It automates the extraction of backups, movement of files, and configuration updates to complete complex migrations in under 5 minutes.

## Features

- **Backup File Extraction**: Extracts tar.gz backup files uploaded to the `/domains/` directory.
- **Domain Selection**: Lists available domains and allows the user to select the target domain for migration.
- **Database Import**: Imports the provided database backup file into the new database.
- **Configuration Update**: Updates the `wp-config.php` file with new database credentials.
- **WordPress Cache Flush**: Flushes the WordPress cache post-migration to ensure smooth performance.

## Prerequisites

1. **Backup Files and Database Upload**:
   - Ensure the backup files (`.tar.gz`) and database SQL files are uploaded to the `/domains/` directory using the Hostinger file manager.
   - Convert any SQL.GZ files to `.SQL` format.

2. **Database Preparation**:
   - Create a new database in your hosting account.
   - Save the database name, user, and password, as these will be required during the script execution.

3. **Empty public_html Directory**:
   - Ensure the `public_html` directory of the sites to be migrated is empty to avoid conflicts during the migration process.

## Usage
