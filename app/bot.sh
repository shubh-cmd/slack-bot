#!/bin/bash

for z in $PWD/app/*.zip;do
    dir=$(echo "$z" | awk -F 'app/' {'print $2'} | cut -d '.' -f1)
    
    unzip -o -q "$z" -d $PWD/app/"$dir"
    uagversion=$(cat $PWD/app/"$dir"/version.info | grep unified | awk -F 'gateway-v' {'print $2'})
    
    curl -X POST -H 'Content-type: application/json' --data '{"text": "'"$dir.zip file has UAG Version=$uagversion"'"}' https://hooks.slack.com/services/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
    
    rm -rf "$z"
    rm -rf $PWD/app/"$dir"
done