#!/bin/bash

set -e -u -o pipefail

readonly BINARY_NAME="terraform"
readonly DOWNLOAD_PACKAGE_PATH="/home/rajesh_debian/terraform_0.12.24_linux_amd64.zip"
readonly DEFAULT_INSTALL_PATH="/opt/$BINARY_NAME"
readonly SYSTEM_BIN_DIR="/usr/local/bin"
readonly USER="rajesh_debian"

function install_binary {
  local readonly install_path="$1"
  local readonly username="$2"

  local readonly bin_dir="$install_path/bin"
  local readonly binary_dest_path="$bin_dir/$BINARY_NAME"

  mkdir -p $bin_dir

  unzip -o -d /tmp "$DOWNLOAD_PACKAGE_PATH"

  sudo mv "/tmp/$BINARY_NAME" "$binary_dest_path"
  sudo chown "$username:$username" "$binary_dest_path"
  sudo chmod a+x "$binary_dest_path"

  local readonly symlink_path="$SYSTEM_BIN_DIR/$BINARY_NAME"
  if [[ -f "$symlink_path" ]]; then
    echo "Symlink $symlink_path already exists. Will not add again."
  else
    echo "Adding symlink to $binary_dest_path in $symlink_path"
    sudo ln -s "$binary_dest_path" "$symlink_path"
  fi
}

install_binary "$DEFAULT_INSTALL_PATH" "$USER"