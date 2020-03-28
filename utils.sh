#!/bin/bash

set -e -o pipefail

function binary_exists {
  local readonly name="$1"

  if [[ ! $(command -v ${name}) ]]; then
    echo "The binary '$name' is required by this script but is not installed or in the system's PATH."
    exit 1
  else
    echo "ok. The binary $name is installed"
  fi
}

binary_exists "git"
binary_exists "curl"

function create_user {
  local readonly username="$1"

  if [[ ! $(id ${username}) ]]; then
    echo "Creating user named $username"
    sudo useradd "$username"
  else
    echo "User $username already exists"
  fi
}

create_user "rajesh_debian"

function arg_not_empty {
  local readonly arg_name="$1"
  local readonly arg_value="$2"

  if [[ -z "$arg_value" ]]; then
    echo "The value for '$arg_name' cannot be empty"
    exit 1
  else
    echo "ok. The value for $arg_name is $arg_value"
  fi
}

VERSION="1.0"
arg_not_empty "--version" "$VERSION"
arg_not_empty "--version"