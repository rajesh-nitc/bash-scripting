#!/bin/bash

if [[ -f ~/bash-scripting/env.sh ]]
then
  echo "file found"
  source ~/bash-scripting/env.sh
  echo $EMAIL
else
 echo "file not found"
fi
