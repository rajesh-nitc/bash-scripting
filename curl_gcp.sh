#!/bin/bash

set -e -u -o pipefail

ACCESS_TOKEN="ya29.c.Ko8BxAdgqD3yt0sZs0lFutETDJVcG_HE-57rXrinu1crAmZPHuF4erMAIBgwvJLnOYUa7Spxk-2ilR8VmrG_MjkLX91Nr4iz8V4av96dr6e8CDuXMsjND1FLIpW83ck6wLc3mGFG81MYaeOVpmxNITxHVIYOsqkD0Q-Hipvz6FZapCmClsX3LthYZJxdCFk_-lM"
URL="https://cloudresourcemanager.googleapis.com/v1/projects/tf-first-project"

function get_project {
  curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $ACCESS_TOKEN" $URL
}

function get_project_state {
  project_state=$(get_project | jq -r '.lifecycleState')
  echo $project_state
}

get_project_state