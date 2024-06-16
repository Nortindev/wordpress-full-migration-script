#!/bin/bash

# Function to list backup files and allow the user to select one
select_backup_file() {
  local backup_path=$1
  backup_files=($(ls "$backup_path" | grep -E "\.tar(\.gz)?$"))
  if [ ${#backup_files[@]} -eq 0 ]; then
    echo "No backup files found in $backup_path."
    exit 1
  fi

  while true; do
    echo "Select a backup file to use:"
    for i in "${!backup_files[@]}"; do
      printf "%s) %s\n" "$((i+1))" "${backup_files[$i]}"
    done

    read -p "Enter the number of the backup file: " backup_number
    if [[ "$backup_number" =~ ^[0-9]+$ ]] && [ "$backup_number" -ge 1 ] && [ "$backup_number" -le "${#backup_files[@]}" ];then
      selected_backup_file="${backup_files[$((backup_number-1))]}"
      break
    else
      echo "Invalid selection. Please enter a number between 1 and ${#backup_files[@]}."
    fi
  done
}

# Function to list domains and allow the user to select one
select_domain() {
  domains=($(ls -d /home/$USER/domains/*/ | grep -v "BACKUP"))
  if [ ${#domains[@]} -eq 0 ]; then
    echo "No domains found."
    exit 1
  fi

  while true; do
    echo "Select a domain to migrate:"
    valid_domains=()
    for i in "${!domains[@]}"; do
      domain_name=$(basename "${domains[$i]}")
      if [ "$domain_name" != "BACKUP" ]; then
        valid_domains+=("$domain_name")
        printf "%s) %s\n" "$((i+1))" "$domain_name"
      fi
    done

    read -p "Enter the number of the domain: " domain_number
    if [[ "$domain_number" =~ ^[0-9]+$ ]] && [ "$domain_number" -ge 1 ] && [ "$domain_number" -le "${#valid_domains[@]}" ]; then
      selected_domain="${valid_domains[$((domain_number-1))]}"
      break
    else
      echo "Invalid selection. Please enter a number between 1 and ${#valid_domains[@]}."
    fi
  done
}

# Function to move files
move_files() {
  local site_path=$1
  local backup_path=$2

  echo "Moving backup files to $site_path/public_html"

  extracted_path="$backup_path/domains/$site_name/public_html"
  if [ -d "$extracted_path" ]; then
    mv "$extracted_path"/* "$site_path/public_html/"
  else
    echo "Extracted path not found. Operation aborted."
    exit 1
  fi
}

# Function to update wp-config.php
update_wp_config() {
  local wp_config_path=$1
  local db_name=$2
  local db_user=$3
  local db_pass=$4

  sed -i "s/define( *'DB_NAME', *'.*' *);/define( 'DB_NAME', '$db_name' );/" "$wp_config_path"
  sed -i "s/define( *'DB_USER', *'.*' *);/define( 'DB_USER', '$db_user' );/" "$wp_config_path"
  sed -i "s/define( *'DB_PASSWORD', *'.*' *);/define( 'DB_PASSWORD', '$db_pass' );/" "$wp_config_path"
}

migrate_site() {
  # Select the domain
  select_domain
  site_name="$selected_domain"
  site_path="/home/$USER/domains/$site_name"

  # Check and create the public_html directory if it doesn't exist
  if [ ! -d "$site_path/public_html" ]; then
    mkdir -p "$site_path/public_html"
  fi

  # Move files to the site's public_html
  move_files "$site_path" "/home/$USER/domains/BACKUP"

  echo "What is the new database name?"
  read new_db_name
  echo "What is the new database user?"
  read new_db_user
  echo "What is the new database password?"
  read -s new_db_pass
  echo "Enter the name of the database backup file (e.g., backup.sql):"
  read db_backup_name

  # Restore the database
  mysql -u"$new_db_user" -p"$new_db_pass" "$new_db_name" < "/home/$USER/domains/$db_backup_name"
  if [ $? -ne 0 ]; then
    echo "Database import failed."
    exit 1
  fi

  # Update wp-config.php
  wp_config_path="$site_path/public_html/wp-config.php"
  update_wp_config "$wp_config_path" "$new_db_name" "$new_db_user" "$new_db_pass"

  # Navigate to the site's public_html directory and run wp cache flush
  cd "$site_path/public_html"
  wp cache flush

  echo "Migration completed successfully."
}

# Script start
while true; do
  while true; do
    echo "Is this backup from Hostinger?"
    echo "1. Yes"
    echo "2. External backup"
    read hostinger_option

    if [[ "$hostinger_option" =~ ^[0-9]+$ ]] && ([ "$hostinger_option" -eq 1 ] || [ "$hostinger_option" -eq 2 ]); then
      break
    else
      echo "Invalid selection. Please enter 1 or 2."
    fi
  done

  if [ "$hostinger_option" == "1" ]; then
    echo "Proceeding with the extraction."
    if [ ! -d /home/$USER/domains/BACKUP ]; then
      select_backup_file "/home/$USER/domains"

      echo "Hostinger backup file selected: $selected_backup_file"
      while true; do
        echo "Has the backup been extracted before? (yes/no)"
        read extracted_before

        if [[ "$extracted_before" == "yes" || "$extracted_before" == "no" ]]; then
          break
        else
          echo "Invalid selection. Please enter yes or no."
        fi
      done

      if [ "$extracted_before" == "no" ]; then
        mkdir -p /home/$USER/domains/BACKUP
        mv "/home/$USER/domains/$selected_backup_file" /home/$USER/domains/BACKUP/
        cd /home/$USER/domains/BACKUP
        tar -xvzf "$selected_backup_file"
      fi
    fi

    migrate_site

    while true; do
      echo "Do you want to migrate another site? (yes/no)"
      read migrate_again

      if [[ "$migrate_again" == "yes" || "$migrate_again" == "no" ]]; then
        break
      else
        echo "Invalid selection. Please enter yes or no."
      fi
    done

    if [ "$migrate_again" != "yes" ]; then
      break
    fi
  else
    echo "External backup selected. Exiting script."
    exit 0
  fi
done
