from rest_framework.views import APIView
from rest_framework.response import Response
import subprocess
import requests
from slack_server.settings import BOT_ID, CLIENT, SLACK_TOKEN, WEBHOOK_URL

# Create your views here.
class SlackView(APIView):
    
    def post(self,request):
        
        if request.data['type'] == "url_verification":
            return Response({"challenge": request.data['challenge']})
        elif request.headers.get('X-Slack-Retry-Num') == '1':
            return Response(status=200,headers={"X-Slack-No-Retry": 1})
        else:
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
                    subprocess.run(['bash','./app/bot.sh', WEBHOOK_URL])
            return Response(status=200,headers={"X-Slack-No-Retry": 1})
