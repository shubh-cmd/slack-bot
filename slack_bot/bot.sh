#!/bin/bash

for z in $PWD/slack_bot/*.zip;do
    dir=$(echo "$z" | awk -F 'slack_bot/' {'print $2'} | cut -d '.' -f1)
    unzip -o -q "$z" -d $PWD/slack_bot/"$dir"
    uagversion=$(cat $PWD/slack_bot/"$dir"/version.info | grep unified | awk -F 'gateway-v' {'print $2'})
    
    curl -X POST -H 'Content-type: application/json' --data '{"text": "'"$dir.zip file has UAG Version=$uagversion"'"}' $1
    
    rm -rf "$z"
    rm -rf $PWD/slack_bot/"$dir"
done