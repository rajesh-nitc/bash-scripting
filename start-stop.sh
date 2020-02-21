#!/bin/bash

CMD=${0##*/}
if [ $# = 0 ] || [ $# = 1 ]
then
    cat <<EOF
USAGE: 
 $CMD {start,stop,status} {service}

EOF
 exit 1
fi

function service_start() {
  systemctl start $2
}

function service_stop(){
  systemctl stop $2
}

function service_status(){
  status=$(systemctl show -p SubState --value $2)
  echo "$2 is $status"
}

case $1 in
    start)
        service_start
        ;;
    stop)
        service_stop
        ;;
    status)
        service_status
        ;;        
    *)
        echo ""
        echo "Unknown command: $1"
        exit 1
        ;;
esac
