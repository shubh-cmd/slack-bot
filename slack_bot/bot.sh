#!/bin/bash

# $1 -> SLACK_TOKEN
# $2 -> current_user
# $3 -> SLACK_CHANNEL
# $4 -> BOT_BASE_DIR
# $5 -> UAG_BASE_DIR
if [ "$(ls -A $5/log-archive)" ]; then 
#    rm -rf /root/uag-self-help/log-archive/*
    rm -rf $5/log-archive/*
fi 

cat $4/$2/inputs.dat > $5/inputs.dat
# rm ./slack_bot/inputs.dat
for z in $4/$2/*.zip;do
    cp $z $5/log-archive
    # cp $z /root/uag-self-help/log-archive 
    # rm -rf "$z"
done 


cmd=$(cd $5 && bash Analyze.sh)

compress=$(cd $5 && zip -rq $4/$2/analysis-logs.zip analysis-logs)

# file_url=$(curl -s -F file=@"/home/shubham/Desktop/projects/server/slack_server/slack_bot/$2/analysis-logs.zip" -F "initial_comment=Result of the analysis" -F channels="$3" -H "Authorization: Bearer $1" https://slack.com/api/files.upload \
#             | python -c "import sys, json; print(json.load(sys.stdin)['file']['url_private_download'])")


# echo $file_url


# rm -rf ./slack_bot/$2
