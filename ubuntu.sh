#!/bin/bash

# Get Ubuntu version codename
UBUNTU_CODENAME=$(lsb_release -c | awk '{print $2}')

# Set the mirror URL
MIRROR_URL="http://ubuntu.parsvds.com/ubuntu"
SECURITY_URL="http://security.ubuntu.com/ubuntu/"

# Check for the correct source file to back up and modify
if [[ "$UBUNTU_CODENAME" == "noble" ]]; then
    SOURCE_FILE="/etc/apt/sources.list.d/ubuntu.sources"
    BACKUP_FILE="/etc/apt/sources.list.d/ubuntu.sources.backup"
    if [ -f "$SOURCE_FILE" ]; then
        sudo cp $SOURCE_FILE $BACKUP_FILE
        echo "Backup of sources list saved as $BACKUP_FILE"
    else
        echo "Source file not found at $SOURCE_FILE"
        exit 1
    fi
else
    # For older versions, backup the old /etc/apt/sources.list file
    SOURCE_FILE="/etc/apt/sources.list"
    BACKUP_FILE="/etc/apt/sources.list.backup"
    if [ -f "$SOURCE_FILE" ]; then
        sudo cp $SOURCE_FILE $BACKUP_FILE
        echo "Backup of sources list saved as $BACKUP_FILE"
    else
        echo "Source file not found at $SOURCE_FILE"
        exit 1
    fi
fi

# Update sources list based on Ubuntu version
case $UBUNTU_CODENAME in
    trusty)
        echo "Detected Ubuntu 14.04 (Trusty Tahr)"
        sudo tee /etc/apt/sources.list <<EOF
deb $MIRROR_URL trusty main restricted universe multiverse
deb $MIRROR_URL trusty-updates main restricted universe multiverse
deb $MIRROR_URL trusty-security main restricted universe multiverse
EOF
        ;;
    xenial)
        echo "Detected Ubuntu 16.04 (Xenial Xerus)"
        sudo tee /etc/apt/sources.list <<EOF
deb $MIRROR_URL xenial main restricted universe multiverse
deb $MIRROR_URL xenial-updates main restricted universe multiverse
deb $MIRROR_URL xenial-security main restricted universe multiverse
EOF
        ;;
    bionic)
        echo "Detected Ubuntu 18.04 (Bionic Beaver)"
        sudo tee /etc/apt/sources.list <<EOF
deb $MIRROR_URL bionic main restricted universe multiverse
deb $MIRROR_URL bionic-updates main restricted universe multiverse
deb $MIRROR_URL bionic-security main restricted universe multiverse
EOF
        ;;
    focal)
        echo "Detected Ubuntu 20.04 (Focal Fossa)"
        sudo tee /etc/apt/sources.list <<EOF
deb $MIRROR_URL focal main restricted universe multiverse
deb $MIRROR_URL focal-updates main restricted universe multiverse
deb $MIRROR_URL focal-security main restricted universe multiverse
EOF
        ;;
    jammy)
        echo "Detected Ubuntu 22.04 (Jammy Jellyfish)"
        sudo tee /etc/apt/sources.list <<EOF
deb $MIRROR_URL jammy main restricted universe multiverse
deb $MIRROR_URL jammy-updates main restricted universe multiverse
deb $MIRROR_URL jammy-security main restricted universe multiverse
EOF
        ;;
    lunar)
        echo "Detected Ubuntu 23.04 (Lunar Lobster)"
        sudo tee /etc/apt/sources.list <<EOF
deb $MIRROR_URL lunar main restricted universe multiverse
deb $MIRROR_URL lunar-updates main restricted universe multiverse
deb $MIRROR_URL lunar-security main restricted universe multiverse
EOF
        ;;
    future)
        echo "Detected Ubuntu 24.04"
        sudo tee /etc/apt/sources.list <<EOF
deb $MIRROR_URL future main restricted universe multiverse
deb $MIRROR_URL future-updates main restricted universe multiverse
deb $MIRROR_URL future-security main restricted universe multiverse
EOF
        ;;
    noble)
        echo "Detected Ubuntu (Noble)"
        # Modify the /etc/apt/sources.list.d/ubuntu.sources file for noble
        sudo tee $SOURCE_FILE <<EOF
Types: deb
URIs: $MIRROR_URL
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF
        ;;
    *)
        echo "Ubuntu version not supported by this script."
        exit 1
        ;;
esac

# Update package lists
sudo apt-get update

echo "Apt sources updated successfully to $MIRROR_URL for Ubuntu $UBUNTU_CODENAME."
