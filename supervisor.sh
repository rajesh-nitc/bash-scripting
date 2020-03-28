#!/bin/bash

set -e -u -o pipefail

function generate_config_supervisor {
  local readonly supervisor_config_path="$1"
  local readonly app1_home="$2"
  local readonly command="$3"
  local readonly log_dir="$4"
  local readonly user="$5"
  cat > "$supervisor_config_path" <<EOF
[program:app1]
directory=$app1_home
command=$command
stdout_logfile=$log_dir/app1-stdout.log
stderr_logfile=$log_dir/app1-error.log
numprocs=1
autostart=true
autorestart=true
stopsignal=INT
user=$user
EOF
}

function start_app1 {
  echo "Reloading Supervisor config and starting app1"
  supervisorctl reread
  supervisorctl update
}

jar_name="springboot-first-0.0.1-SNAPSHOT"
generate_config_supervisor "/etc/supervisor/conf.d/app1.conf" "/opt/app1" "java -jar target/$jar_name.jar" "/opt/logs" "app1"
start_app1