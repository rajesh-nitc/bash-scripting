#!/bin/bash

set -e -u -o pipefail

readonly SYSTEM_BIN_DIR="/usr/local/bin"
readonly USER="rajesh_debian"

function usage {
  echo "Example:"
  echo "./install_binary.sh --install-path /opt/terraform --binary-name terraform --package-zip-path /home/rajesh_debian/terraform_0.12.24_linux_amd64.zip"
}

function arg_not_empty {
  local readonly arg_name="$1"
  local readonly arg_value="$2"

  if [[ -z "$arg_value" ]]; then
    echo "The value for '$arg_name' cannot be empty"
    usage
    exit 1
  fi
}

function install_binary {

  local install_path=""
  local binary_name=""
  local package_zip_path=""

  while [[ $# > 0 ]]; do
    local key="$1"

    case "$key" in
      --install-path)
        install_path="$2"
        shift
        ;;
      --binary-name)
        binary_name="$2"
        shift
        ;;
      --package-zip-path)
        package_zip_path="$2"
        shift
        ;;
      *)
        echo "Unrecognized argument: $key"
        usage
        exit 1
        ;;
    esac
    shift
  done

  arg_not_empty "--install-path" "$install_path"
  arg_not_empty "--binary-name" "$binary_name"
  arg_not_empty "--package-zip-path" "$package_zip_path"

  local readonly install_path="$install_path"
  local readonly binary_name="$binary_name"
  local readonly package_zip_path="$package_zip_path"
  local readonly username="$USER"
  local readonly bin_dir="$install_path/bin"
  local readonly binary_dest_path="$bin_dir/$binary_name"

  mkdir -p $bin_dir

  unzip -o -d /tmp "$package_zip_path"

  sudo mv "/tmp/$binary_name" "$binary_dest_path"
  sudo chown "$username:$username" "$binary_dest_path"
  sudo chmod a+x "$binary_dest_path"

  local readonly symlink_path="$SYSTEM_BIN_DIR/$binary_name"
  if [[ -f "$symlink_path" ]]; then
    echo "Symlink $symlink_path already exists. Will not add again."
  else
    echo "Adding symlink to $binary_dest_path in $symlink_path"
    sudo ln -s "$binary_dest_path" "$symlink_path"
  fi
}

install_binary "$@"