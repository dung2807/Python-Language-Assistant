#coding = <utf8>
import os
import grammar_check
import sys
import json
import codecs
import tts
import words
import requests
from flask import Flask, request

grammarUserID = dict()

app = Flask(__name__)
sys.stdout = codecs.getwriter('utf_8')(sys.stdout)

sys.stdin = codecs.getreader('utf_8')(sys.stdin)


@app.route('/', methods=['GET'])
def verify():
    # when the endpoint is registered as a webhook, it must
    # return the 'hub.challenge' value in the query arguments
    if request.args.get("hub.mode") == "subscribe" and request.args.get("hub.challenge"):
        if not request.args.get("hub.verify_token") == os.environ["VERIFY_TOKEN"]:
            return "Verification token mismatch", 403
        return request.args["hub.challenge"], 200

    return "Hello world", 200


@app.route('/', methods=['POST'])
def webook():

    # endpoint for processing incoming messaging events
    #return "Hello world", 200
    data = request.get_json()
    log(data)  # you may not want to log every incoming message in production, but it's good for testing

    if data["object"] == "page":
        for entry in data["entry"]:
            for messaging_event in entry["messaging"]:
                if messaging_event.get("message"):  # someone sent us a message
                    sender_id = messaging_event["sender"]["id"]        # the facebook ID of the person sending you the message
                    if sender_id == u'1774667882802558':
                        log(sender_id)
                        return "ok", 200
                    recipient_id = messaging_event["recipient"]["id"]  # the recipient's ID, which should be your page's facebook ID
                    send_process(sender_id)
                    send_settings()
                    message_text = messaging_event["message"].get("text")
                    option = messaging_event["message"].get("quick_reply")
                    log(option)
                    log(grammarUserID)
                    if grammarUserID.get(sender_id) == 1:
                        grammarUserID[sender_id] = 0
                        log(grammarUserID)
                        tool = grammar_check.LanguageTool('en-US') 
                        tmp = tool.check(message_text)
                        outp = ''
                        log(tmp)
                        #for mis in tmp : 
                        #    outp += mis + '\n'
                        outp = grammar_check.correct(message_text, tmp)
                        send_message(sender_id, "Correct: " + outp)
                        return "ok", 200
                    if option is not None:
                        opt = messaging_event["message"]["quick_reply"]["payload"]
                        log(opt)
                        option_catch(opt,sender_id)
                    else:
                        if option is None:
                            option = messaging_event.get("messaging")
                        if option is not None:
                            opt = option[0]["postback"]["payload"]
                            option_catch(opt,sender_id)
                            return "ok", 200
                        if message_text is not None:
                            if message_text == 'Setting':
                                quick_replies = [["Volcabulary", "Vocab"], ["Grammar-Check","Gramma"],["Category", "Cate"]]
                                send_quickReplies(sender_id, "Which option do you choose?", quick_replies)
                            else:
                                send_Define(sender_id, message_text)

                    #else:
                        #messageType = messaging_event["message"].get("text")
                        #if messageType == 'audio':
                            #pass
                        #change to text

                if messaging_event.get("delivery"):  # delivery confirmation
                    pass

                if messaging_event.get("optin"):  # optin confirmation
                    pass

                if messaging_event.get("postback"):  # user clicked/tapped "postback" button in earlier message
                    pass
    return "ok", 200

def option_catch(opt, sender_id):
    if opt == "Vocab":
        #send_message(sender_id, "You chose "+str(opt))
        word1 = words.generateWord("people",sender_id)
        word2 = words.someExam(word1['word'],"people")
        quick_replies = [[word1['word'],'w1'], [word2[1], 'w2']]
        send_quickReplies(sender_id, word1['meaning'], quick_replies )
    elif opt == "Gramma":
        grammarUserID[sender_id] = 1
        log(grammarUserID)
        send_message(sender_id, "Which sentence do you want to check for grammar or typos mistakes?")
        # nhap chuoi ki tu tu fb mess
        """
        tmp = tool.check(s)
        outp = ''
        log(tmp)
        for mis in tmp : 
            outp += mis + '\n'
        send_message(sender_id, outp)
        """          
    elif opt == "Cata":
        quick_replies = [["People", "Peo"], ["Economy","Econo"],["Health", "Heal"]]
        send_quickReplies(sender_id, "Which option do you choose?", quick_replies)
        send_message(sender_id, "Chu de cua ban la: " + str(opt1))# underconstruction, will be finished if we receive the $80000 price 
    elif opt =="w1":
        send_message(sender_id, "You're correct")
    elif opt == "w2":
        send_message(sender_id, "You're not correct") 
       
def send_Define(recipient_id, text):
    send_template(recipient_id, text)
    temp = tts.gTTS(text, lang = 'en')
    temp.write_to_fp()
    send_attachment(recipient_id, 'audio',temp.returnURL)

def send_template(recipient_id, text):
    log("sending define to {recipient}: {text}".format(recipient=recipient_id, text=text))
    image_URL = "http://www.hotel-r.net/im/hotel/fr/hello-1.jpg" #getimage.getimage(text)
    params = {
        "access_token": os.environ["PAGE_ACCESS_TOKEN"]
    }
    headers = {
        "Content-Type": "application/json"
    }
    data = json.dumps({
        "recipient": {
            "id": recipient_id
        },
        "message": {
            "attachment":{
            "type":"template",
            "payload":{
                "template_type":"generic",
                "elements":[
                {
                    "title":text,
                    "image_url": image_URL
                }
            ]
      }
    }
        }
    })
    r = requests.post("https://graph.facebook.com/v2.6/me/messages", params=params, headers=headers, data=data)
    if r.status_code != 200:
        log(r.status_code)
        log(r.text)

def send_image(recipient_id, URL):
    log("sending message to {recipient}: {text}".format(recipient=recipient_id, text=URL))
    send_attachment(recipient_id, "image", URL)

def send_message(recipient_id, message_text):
    log("sending message to {recipient}: {text}".format(recipient=recipient_id, text=message_text))
    params = {
        "access_token": os.environ["PAGE_ACCESS_TOKEN"]
    }
    headers = {
        "Content-Type": "application/json"
    }
    data = json.dumps({
        "recipient": {
            "id": recipient_id
        },
        "message": {
            "text": message_text
        }
    })
    r = requests.post("https://graph.facebook.com/v2.6/me/messages", params=params, headers=headers, data=data) 
    if r.status_code != 200:
        log(r.status_code)
        log(r.text)

def send_attachment(recipient_id, attachmentType, attachmentURL):
    log("sending message to {recipient}: {text} and {url}".format(recipient=recipient_id, text=attachmentType, url = attachmentURL))

    params = {
        "access_token": os.environ["PAGE_ACCESS_TOKEN"]
    }
    headers = {
        "Content-Type": "application/json"
    }
    data = json.dumps({
        "recipient": {
            "id": recipient_id
        },
        "message": {
            "attachment":{
            "type":attachmentType,
            "payload":{
                "url": attachmentURL
                }
            }
        }
    })
    r = requests.post("https://graph.facebook.com/v2.6/me/messages", params=params, headers=headers, data=data)
    if r.status_code != 200:
        log(r.status_code)
        log(r.text)

def send_quickReplies(recipient_id, message, quick_replies):
    log("sending message to {recipient}: {text} and {quick}".format(recipient=recipient_id, text=message, quick = quick_replies))
    quick = []
    for q in quick_replies:
        quick += [{"content_type":"text","title":q[0],"payload":q[1]}]
    params = {
        "access_token": os.environ["PAGE_ACCESS_TOKEN"]
    }
    headers = {
        "Content-Type": "application/json"
    }
    data = json.dumps({
        "recipient": {
            "id": recipient_id
        },
        "message": {
            "text": message,
            "quick_replies": quick
        }
    })
    r = requests.post("https://graph.facebook.com/v2.6/me/messages", params=params, headers=headers, data=data)
    log(r)
    if r.status_code != 200:
        log(r.status_code)
        log(r.text)

def send_corfirmYN(recipient_id, message):
    quick_replies =[["Yes","Yes"], ["No", "No"]]
    log("sending message to {recipient}: {text} and {quick}".format(recipient=recipient_id, text=message, quick = quick_replies))
    send_quickReplies(recipient_id, message, quick_replies)

def send_process(recipient_id):
    log("sending message to {recipient}: processing...".format(recipient=recipient_id))
    #send_mess(recipient_id, {"sender_action":"typing_on"})
    params = {
        "access_token": os.environ["PAGE_ACCESS_TOKEN"]
    }
    headers = {
        "Content-Type": "application/json"
    }
    data = json.dumps({
        "recipient": {
            "id": recipient_id
        },
        "sender_action":"typing_on"
    })
    r = requests.post("https://graph.facebook.com/v2.6/me/messages", params=params, headers=headers, data=data)
    if r.status_code != 200:
        log(r.status_code)
        log(r.text)

def send_settings():
    log("sending message to {recipient}: {text}".format(recipient="Everyone", text="Settings"))

    params = {
        "access_token": os.environ["PAGE_ACCESS_TOKEN"]
    }
    headers = {
        "Content-Type": "application/json"
    }
    data = json.dumps({
        "setting_type" : "call_to_actions",
        "thread_state" : "existing_thread",
        "call_to_actions":[{
                "type":"postback",
                "title":"Remind",
                "payload":"Remind"
            },
            {
                "type":"postback",
                "title":"Words per day",
                "payload":"Words per day"
            },
            {
                "type":"postback",
                "title":"Grammar-Check",
                "payload":"Gramma"
            }]
        })
    r = requests.post("https://graph.facebook.com/v2.6/me/thread_settings", params=params, headers=headers, data=data)
    if r.status_code != 200:
        log(r.status_code)
        log(r.text)

def log(message):  # simple wrapper for logging to stdout on heroku
    print str(message)
    sys.stdout.flush()


if __name__ == '__main__':
    app.run(debug=True)