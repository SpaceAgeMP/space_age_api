import requests
from sys import argv

APP_ID = argv[1]
BOT_TOKEN = argv[2]

url = f"https://discord.com/api/v10/applications/{APP_ID}/commands"
headers = {
    "Authorization": f"Bot {BOT_TOKEN}"
}

old_commands = requests.get(url, headers=headers).json()
for command in old_commands:
    print(f"Deleting {command['name']}")
    requests.delete(f"{url}/{command['id']}", headers=headers)

# This is an example CHAT_INPUT or Slash Command, with a type of 1
json = {
    "name": "salink",
    "type": 1,
    "description": "Link SpaceAge to Discord",
    "options": [
        {
            "name": "code",
            "description": "Link code. Use \"unlink\" to unlink any existing account",
            "type": 3,
            "required": True
        }
    ]
}



r = requests.post(url, headers=headers, json=json)
r.raise_for_status()
print(r.text)
