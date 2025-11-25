#!/usr/bin/env python3
import os, socket, subprocess, datetime, psutil, requests

print("\033c")  # clear screen

print("=== Server Dashboard ===\n")
print("Server:", socket.gethostname())
print("Uptime:", subprocess.getoutput("uptime -p"))
print()

print("Current user:", os.getlogin())
print("Date:", datetime.datetime.now())
print()

print("=== Disk Usage ===")
for part in psutil.disk_partitions():
    usage = psutil.disk_usage(part.mountpoint)
    print(part.mountpoint, usage.percent, "%")
print()

print("=== Memory ===")
print(psutil.virtual_memory())
print()

print("=== CPU ===")
print("Load avg:", os.getloadavg())
print()

print("External IP:", requests.get("https://icanhazip.com").text.strip())
print()

print("=== Last 3 login attempts ===")
print(subprocess.getoutput("last -n 3"))

