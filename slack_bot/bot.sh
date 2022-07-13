#!/bin/bash
export TERM=xterm
if [ "$(ls -A /home/selfhelp/projects/uag-self-help/log-archive)" ]; then 
#    rm -rf /root/uag-self-help/log-archive/*
    rm -rf /home/selfhelp/projects/uag-self-help/log-archive/*
fi 


echo $(ls /home/selfhelp/projects/uag-bot/slack_bot)
cat /home/selfhelp/projects/uag-bot/slack_bot/inputs.dat > /home/selfhelp/projects/uag-self-help/inputs.dat
rm -f /home/selfhelp/projects/uag-bot/slack_bot/inputs.dat
for z in /home/selfhelp/projects/uag-bot/slack_bot/*.zip;do
    cp $z /home/selfhelp/projects/uag-self-help/log-archive
    # cp $z /root/uag-self-help/log-archive 
    rm -rf "$z"
done 

cmd=$(cd /home/selfhelp/projects/uag-self-help && bash Analyze.sh)
#echo $(ls /home/selfhelp/projects/uag-self-help/analysis-logs)
compress=$(cd /home/selfhelp/projects/uag-self-help && zip -rq /home/selfhelp/projects/uag-bot/slack_bot/analysis-logs.zip analysis-logs)

curl -s -F file=@"/home/selfhelp/projects/uag-bot/slack_bot/analysis-logs.zip" -F "initial_comment=Result of the analysis" -F channels="C03L2T10R43" -H "Authorization: Bearer $1" https://slack.com/api/files.upload -o /dev/null

rm -rf /home/selfhelp/projects/uag-bot/slack_bot/analysis-logs.zip

echo $(ls /home/selfhelp/projects/uag-bot/slack_bot)
