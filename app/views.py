from traceback import print_tb
from django.conf import settings
from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from django.conf import settings
import subprocess
import requests
from slack_server.settings import BOT_ID, CLIENT, SLACK_TOKEN
EVENT_ID = None
# Create your views here.
class SlackView(APIView):
    
    def post(self,request):
        global EVENT_ID
        
        if request.data['type'] == "url_verification":
            return Response({"challenge": request.data['challenge']})
        elif request.data['event_id'] == EVENT_ID:
            return Response(status=200)
        else:
            EVENT_ID = request.data['event_id']
            e = request.data['event'] 
            if e['type'] == 'file_shared' and e['user_id'] != BOT_ID:
                res = CLIENT.files_info(file=str(e['file_id']))
                if res['file']['filetype'] == 'zip':
                    
                    file_name = res['file']['name']
                    file_url = res['file']['url_private']
                    r = requests.get(file_url, headers={'Authorization': f'Bearer {SLACK_TOKEN}'})
                    r.raise_for_status()
                    file_data = r.content   
                    with open('./app/'+file_name , 'w+b') as f:
                      f.write(bytearray(file_data))
                    subprocess.run(['bash','./app/bot.sh'])
            return Response(status=200)
