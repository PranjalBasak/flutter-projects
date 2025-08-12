import requests

def print_request(req):
    print(f"{req.method} {req.url}")
    for k, v in req.headers.items():
        print(f"{k}: {v}")
    print()
    if req.body:
        try:
            print(req.body.decode())
        except:
            print(req.body)

url = "https://labs.anontech.info/cse489/t3/api.php"
files = {'image': open(r"E:\Download v2\Images\image22.jpg", 'rb')}
data = {
    'title': 'Test Place',
    'lat': '23.81',
    'lon': '90.41'
}

session = requests.Session()
req = requests.Request('POST', url, data=data, files=files)
prepped = session.prepare_request(req)

print("---- REQUEST ----")
print_request(prepped)

try:
    resp = session.send(prepped)
    print("\n---- RESPONSE ----")
    print(f"Status code: {resp.status_code}")
    print("Headers:", resp.headers)
    print("Content:", resp.text)
    resp.raise_for_status()
except requests.RequestException as e:
    print(f"Request failed: {e}")
