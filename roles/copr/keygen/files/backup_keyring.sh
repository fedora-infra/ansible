#!/bin/sh

# - used as root
# - executed hourly, overwriting the "daily file" in /backup dir
# - the Fedora Infra backup mechanism pulls that file, overwriting its own
#   "daily" copy
# - it means we should always have at most a 24h-old backup
# - the root gpg keychain should have PUBLIC key with `user name`
#   copr-keygen-backup-key, per
#   https://pagure.io/fedora-infrastructure/issue/8904
# - fixed in https://github.com/fedora-copr/copr/issues/3532

PATH_TO_KEYRING_DIR="/var/lib/copr-keygen"
BACKUP_DIR=/backup
OUTPUT_FILE="$BACKUP_DIR/copr_keygen_keyring_$(date -I).tar.gz.gpg"

tar --exclude="*agent*" -czPf - "$PATH_TO_KEYRING_DIR" \
    | gpg2 --output "$OUTPUT_FILE".tmp --encrypt \
           --recipient-file /root/backup_key.asc \
&& mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"

# shell pattern matching provides sorted output
previous=
for file in "$BACKUP_DIR"/*; do
    test -z "$previous" || rm "$previous"
    previous=$file
done
