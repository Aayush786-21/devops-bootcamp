#!/usr/bin/env python3
import subprocess, os, datetime, textwrap

report = "harden_report.txt"
open(report, "w").write("Hardening Report " + str(datetime.datetime.now()) + "\n\n")

def run(cmd):
    subprocess.run(cmd, shell=True, check=False)

# Disable root login and change SSH port
sshd = "/etc/ssh/sshd_config"
run(f"sudo cp {sshd} {sshd}.bak")

run("sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config")
run("sudo sed -i 's/^#*Port.*/Port 2222/' /etc/ssh/sshd_config")

# Install fail2ban
run("sudo apt-get install -y fail2ban || sudo yum install -y fail2ban")

# Write simple jail.local
run("echo -e '[sshd]\\nenabled=true' | sudo tee /etc/fail2ban/jail.local")
run("sudo systemctl restart fail2ban")

# Disable some services
for svc in ["cups", "rpcbind", "nfs-server"]:
    run(f"sudo systemctl disable --now {svc}")

# Setup UFW firewall
run("sudo ufw allow 2222/tcp")
run("sudo ufw allow 80")
run("sudo ufw allow 443")
run("sudo ufw --force enable")

open(report, "a").write("Hardening complete.\n")

