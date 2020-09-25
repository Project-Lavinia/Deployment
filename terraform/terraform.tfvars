# Region
region = "osl"

# This is needed to access the instance over ssh
allow_ssh_from_v6 = [
  "2a01:79d:53aa:1214:970:105f:5c4:7654/128",
]
allow_ssh_from_v4 = [
  "84.234.132.133/32",
  "78.156.3.46/32"
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
