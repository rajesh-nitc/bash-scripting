#!/bin/bash

function syncRepos(){
    # Capture the Arguments
    name_arg=$1
    url_arg=$2
    echo "$name_arg & $url_arg"
    # git commands
}

# jq compact is important for looping
# removes whitespace and each element is put on a single line:
# see the output of jq -c '.[]' repos.json, each element on single line:
# {"projectName":"repo1","gitUrl":"https://repo1.git"}
# {"projectName":"repo2","gitUrl":"https://repo2.git"}

# without compact option, there will be whitespace
# and each element in the array will span over multiple lines
# making it difficult to treat it as single item while looping

for i in $(jq -c '.[]' repos.json); do
 name=$(echo $i | jq '.projectName')
 url=$(echo $i | jq '.gitUrl')
 syncRepos $name $url
 sleep 5   
done