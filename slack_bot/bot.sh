#!/bin/bash

if [ "$(ls -A ~/Downloads/uag-self-help/log-archive)" ]; then 
#    rm -rf /root/uag-self-help/log-archive/*
    rm -rf ~/Downloads/uag-self-help/log-archive/*
fi 

cat $PWD/slack_bot/inputs.dat > ~/Downloads/uag-self-help/inputs.dat
rm ./slack_bot/inputs.dat
for z in $PWD/slack_bot/*.zip;do
    cp $z ~/Downloads/uag-self-help/log-archive
    # cp $z /root/uag-self-help/log-archive 
    rm -rf "$z"
done 

cmd=$(cd ~/Downloads/uag-self-help && bash Analyze.sh)

compress=$(cd ~/Downloads/uag-self-help && zip -rq /home/shubham/Desktop/projects/server/slack_server/slack_bot/analysis-logs.zip analysis-logs)

curl -s -F file=@"/home/shubham/Desktop/projects/server/slack_server/slack_bot/analysis-logs.zip" -F "initial_comment=Result of the analysis" -F channels="C03L2T10R43" -H "Authorization: Bearer $1" https://slack.com/api/files.upload -o /dev/null

rm -rf ./slack_bot/analysis-logs.zip