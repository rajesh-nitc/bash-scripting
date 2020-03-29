#!/bin/bash

function foo(){
    name_arg=$1
    url_arg=$2
    echo "$name_arg and $url_arg"
}

for i in $(jq -c '.[]' sample.json); do
 name=$(echo $i | jq '.name')
 url=$(echo $i | jq '.url')
 foo $name $url 
done

# sample.json
# [
#     {
#         "name": "name1",
#         "url": "url1"
#     },
#     {
#         "name": "name2",
#         "url": "url2"
#     }
# ]