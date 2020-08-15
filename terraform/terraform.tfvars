# Region
region = "osl"

# This is needed to access the instance over ssh
allow_ssh_from_v6 = [
  "2a01:79d:53aa:1214:970:105f:5c4:7654/128",
  "fe80::9de0:88d9:c480:2780/128"
]
allow_ssh_from_v4 = [
  "84.234.132.133/32",
  "185.129.158.182/32"
]

# This is needed to access the instance over http
allow_http_from_v6 = [
  "2a01:79d:53aa:1214:970:105f:5c4:7654/40"
]
allow_http_from_v4 = [
  "84.234.132.133/16",
  "185.129.158.182/16"
]
