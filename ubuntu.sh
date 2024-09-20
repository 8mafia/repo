#!/bin/bash

# Get Ubuntu version codename
UBUNTU_CODENAME=$(lsb_release -c | awk '{print $2}')

# Backup the current sources list
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Set the mirror URL
MIRROR_URL="http://ubuntu.parsvds.com/ubuntu"

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
    *)
        echo "Ubuntu version not supported by this script."
        exit 1
        ;;
esac

# Update package lists
sudo apt-get update

echo "Apt sources updated successfully to $MIRROR_URL for Ubuntu $UBUNTU_CODENAME."
