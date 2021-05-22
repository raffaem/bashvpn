#!/usr/bin/env bash

# This script changes the OpenVPN configuration files
# To read credentials from a file instead of asking the user
# The credential file must contain:
# The username in the first line
# The password in the second line
# OVPN configuration files are changed in place
# after a backup copy is created
# This saves sensible credentials into a file. Use with caution!
# It is useful when you want to start the service at boot 
# without asking for credentials each time
# Call it like:
# change_auth_user_pass.sh [DIRECTORY_WITH_OVPN_FILES] [CREDENTIALS_FILE]

if [[ ! -d $1 ]]; then
    echo "Error: $1 is not a directory"
    exit
fi

if [[ ! -f $2 ]]; then
    echo "Error: $2 is not a file"
    exit
fi

for f in $1/*; 
do
    echo "Changing $f ..."
    # Escape backslash to avoid sed thinks we are separating its arguments
    rep=${2//\//\\\/}
    sed -i.bak "s/auth-user-pass/auth-user-pass $rep/g" $f
done
