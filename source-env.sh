#!/bin/bash

if [[ -f ~/bash-scripting/env.sh ]]
then
  echo "file found"
  source ~/bash-scripting/env.sh
  echo $MYEMAIL
else
 echo "file not found"
fi