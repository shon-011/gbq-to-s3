import sys
import slackweb

def slack_post(body=None):
    if sys.argv[1:2]:
        text = sys.argv[1]
    else:
        text=body
    
    try:
        url = "[your_slack_url]"
        slack = slackweb.Slack(url=url)
        slack.notify(text=text)
    except Exception as ex:
        print(ex)
        exit(0)
        
if __name__ == '__main__':
  slack_post()