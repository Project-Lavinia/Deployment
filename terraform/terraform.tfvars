# Region
region = "osl"

# This is needed to access the instance over ssh
allow_ssh_from_v6 = [
]
allow_ssh_from_v4 = [
  "80.203.120.208/32"
]

# This is needed to access the instance over http
allow_http_from_v6 = [
  "::/0"
]
allow_http_from_v4 = [
  "0.0.0.0/0"
]
allow_https_from_v6 = [
  "::/0"
]
allow_https_from_v4 = [
  "0.0.0.0/0"
]
