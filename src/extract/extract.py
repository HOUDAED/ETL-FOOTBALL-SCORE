import os
import json
import requests
from dotenv import load_dotenv

load_dotenv()

token = os.getenv("API_KEY")
url = os.getenv("API_URL")

if not token or not url:
    raise RuntimeError("API_KEY ou API_URL manque dans le fichier .env")

response = requests.get(
    url,
    headers={"X-Auth-Token": token},
    params={"season": 2026},
    timeout=30,
)

response.raise_for_status()
data = response.json()
os.makedirs("data", exist_ok=True)

with open("data/matchs_2026.json", "w", encoding="utf-8") as fichier:
    json.dump(data, fichier, ensure_ascii=False, indent=2)
matches = data["matches"]

print("Compétition :", data["competition"]["name"])
print("Saison :", data["filters"]["season"])
print("Matchs annoncés :", data["resultSet"]["count"])
print("Matchs reçus :", len(matches))

if matches:
    first_match = matches[0]
    print(
        "Premier match :",
        first_match["homeTeam"]["name"],
        "-",
        first_match["awayTeam"]["name"],
    )
else:
    print("Aucun match dans la réponse.")