#!/usr/bin/env bash

# This script restores the backup files
# change_auth_user_pass_restore.sh [DIRECTORY_WITH_OVPN_FILES]

if [[ ! -d $1 ]]; then
    echo "Error: $1 is not a directory"
    exit
fi

# Remove original files
rm -r $1/*.ovpn

# Rename backup files
for f in $1/*;
do
    # Remove final extension (.bak) 
    # to obtain original filename 
    newname=${f%.*}
    echo "Moving $f -> $newname"
    mv $f $newname
done
