import requests
from sys import argv

APP_ID = argv[1]
BOT_TOKEN = argv[2]

url = f"https://discord.com/api/v10/applications/{APP_ID}/commands"

# This is an example CHAT_INPUT or Slash Command, with a type of 1
json = {
    "name": "sa",
    "type": 1,
    "description": "Commands for interacting with SpaceAge",
    "options": [
        {
            "name": "operation",
            "description": "What to do",
            "type": 3,
            "required": True,
            "choices": [
                {
                    "name": "link",
                    "value": "link"
                },
                {
                    "name": "unlink",
                    "value": "unlink"
                }
            ]
        }
    ]
}

headers = {
    "Authorization": f"Bot {BOT_TOKEN}"
}

r = requests.post(url, headers=headers, json=json)
r.raise_for_status()
print(r.text)
