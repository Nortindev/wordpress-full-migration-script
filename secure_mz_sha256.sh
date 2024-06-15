#!/bin/bash

# URLs of the script and the hash file
SCRIPT_URL="https://raw.githubusercontent.com/Nortindev/wordpress-full-migration-script/main/mz.sh"
HASH_URL="https://raw.githubusercontent.com/Nortindev/wordpress-full-migration-script/main/mz.sh.sha256"

# Names of the downloaded files
SCRIPT_FILE="mz.sh"
HASH_FILE="mz.sh.sha256"

# Download the script and the hash file
curl -O $SCRIPT_URL
curl -O $HASH_URL

# Read the expected hash from the .sha256 file
expected_hash=$(cat $HASH_FILE)

# Calculate the hash of the downloaded script
downloaded_hash=$(sha256sum $SCRIPT_FILE | awk '{print $1}')

# Compare the hashes
if [ "$expected_hash" != "$downloaded_hash" ]; then
  echo "Error: SHA256 hash mismatch. The script may have been tampered with."
  rm $SCRIPT_FILE $HASH_FILE
  rm -- "$0"  # Remove the secure_mz_sha256.sh script itself
  exit 1
fi

# Execute the script if the hashes match
sh $SCRIPT_FILE

# Cleanup: Remove the hash file and the secure_mz_sha256.sh script
rm $HASH_FILE
rm -- "$0"  # Remove the secure_mz_sha256.sh script itself
