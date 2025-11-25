#!/bin/bash

REPORT="/var/log/harden-report.txt"
SSH_CONFIG="/etc/ssh/sshd_config"

echo "===== Server Hardening Report =====" > $REPORT
echo "Date: $(date)" >> $REPORT
echo "" >> $REPORT

# Disable root login
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' $SSH_CONFIG
echo "Root login disabled via SSH" >> $REPORT

# Change SSH port
NEW_PORT=2222
sed -i "s/^#Port .*/Port $NEW_PORT/" $SSH_CONFIG
echo "SSH port changed to $NEW_PORT" >> $REPORT

# Restart SSH
systemctl restart sshd

# Install fail2ban
apt update -y
apt install fail2ban -y
systemctl enable fail2ban
systemctl start fail2ban
echo "Fail2ban installed and enabled" >> $REPORT

# Disable unused services
for svc in avahi-daemon cups rpcbind ufw; do
    if systemctl is-active --quiet $svc; then
        systemctl stop $svc
        systemctl disable $svc
        echo "Disabled service: $svc" >> $REPORT
    fi
done

# Set up firewall (UFW)
apt install ufw -y
ufw default deny incoming
ufw default allow outgoing
ufw allow $NEW_PORT/tcp
ufw enable
echo "Firewall configured using UFW" >> $REPORT

echo "" >> $REPORT
echo "===== Final Status =====" >> $REPORT
echo "" >> $REPORT

echo "SSH Port: $NEW_PORT" >> $REPORT
echo "Firewall: UFW active" >> $REPORT
echo "Fail2ban: $(systemctl is-active fail2ban)" >> $REPORT

echo "Hardening complete. Report saved to $REPORT"

