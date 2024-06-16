# WordPress Site Migration Script
WordPress full migration script for backups created at Hostinger

## Overview

This bash script facilitates the migration of WordPress sites hosted on Hostinger. It automates the extraction of backups, movement of files, and configuration updates to complete complex migrations in under 5 minutes.

## Video Demonstration
https://www.loom.com/share/d50c4fef06ff415394d5269562f909aa?sid=0621c39b-7eea-45e4-b76c-8c0a84df113a

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

1. **Execute the Script via cURL**:
   ```bash
   curl -O https://raw.githubusercontent.com/Nortindev/wordpress-full-migration-script/main/mz.sh ; sh mz.sh

2. **Follow the Prompts**:

   - Select whether the backup is from Hostinger or an external source.
   - Select the backup file to use.
   - Confirm if the backup has been extracted before.
   - Select the domain to migrate.
   - Provide the new database credentials.
   - Provide the name of the database backup file.
  
## Example
After running the script, you will be prompted to make selections and enter information as shown below:

   - Is this backup from Hostinger?
   - 1. Yes
   - 2. External backup
   - Enter your choice: 1
   - Proceeding with the extraction.
   - Select a backup file to use:
   - 1) yourdomain.20240615004657.tar.gz
   - Enter the number of the backup file: 1
   - Hostinger backup file selected: yourdomain.20240615004657.tar.gz
   - Has the backup been extracted before? (yes/no): no
   - Moving backup files to /home/youruser/domains/yourdomain/public_html
   - What is the new database name? yourdatabase
   - What is the new database user? yourdbuser
   - What is the new database password? yourdbpassword
   - Enter the name of the database backup file (e.g., backup.sql): yourdatabase.sql
   - Database import successful.   
   - Updating wp-config.php with new database credentials.
   - Migration completed successfully.
   - Do you want to migrate another site? (yes/no): no

## Optional Usage - Download with SHA256 for extra security.

1. **Execute the Script via cURL with SHA256 verification**:
   ```bash
   curl -O https://raw.githubusercontent.com/Nortindev/wordpress-full-migration-script/main/secure_mz_sha256.sh ; sh secure_mz_sha256.sh


## Conclusion
This script simplifies the process of migrating WordPress sites, ensuring that even complex migrations can be completed efficiently and effectively. By following the prerequisites and usage instructions, you can migrate your WordPress site with minimal downtime and effort.
