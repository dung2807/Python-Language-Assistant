import json
from googleapiclient.discovery import build

service = build("customsearch", "v1",
         developerKey="AIzaSyDGoE3mWCPL-M0KiEiPU0KWo274I9FDgWI")

def getimage(query):
    res = service.cse().list(
        #q la bien can querry
        q = query,
        cx='016227321730430650934:xnyrzz_wbz0',
        searchType = 'image',
        num = 1,
        ).execute()
    return res['items'][0]['link']
