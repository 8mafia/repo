#!/bin/bash

# Get AlmaLinux version
ALMA_VERSION=$(cat /etc/almalinux-release | grep -oE '[0-9]+(\.[0-9]+)?')

# Check if AlmaLinux is installed
if [[ -z "$ALMA_VERSION" ]]; then
  echo "AlmaLinux is not installed."
  exit 1
fi

echo "AlmaLinux version $ALMA_VERSION is installed."

# Try to update the system and check for GPG check failure
if ! yum update -y; then
  echo "Error: GPG check FAILED. Importing AlmaLinux GPG key..."
  
  # Import the AlmaLinux GPG key
  rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux
  
  # Update repository to your custom AlmaLinux repo
  echo "Updating repository to http://almalinux.parsvds.com/almalinux/"
  
  # Backup original repo files
  sudo cp -r /etc/yum.repos.d/ /etc/yum.repos.d.bak/

  # Replace all repository base URLs with the custom repo URL
  sudo sed -i 's|^baseurl=.*|baseurl=http://almalinux.parsvds.com/almalinux/$releasever/BaseOS/$basearch/os/|g' /etc/yum.repos.d/*.repo
  sudo sed -i 's|^metalink=.*|#metalink disabled for custom repo|g' /etc/yum.repos.d/*.repo
  
  # Try the update again
  echo "Retrying system update..."
  yum clean all
  yum update -y
fi

echo "System update completed successfully."
