#!/usr/bin/env python3
import psutil, requests

print("Private IP(s):")
for iface, addrs in psutil.net_if_addrs().items():
    for a in addrs:
        if a.family == 2 and not a.address.startswith("127."):
            print(" -", a.address)

print("\nPublic IP:")
print(" -", requests.get("https://icanhazip.com").text.strip())

