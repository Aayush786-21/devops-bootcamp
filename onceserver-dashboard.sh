#!/bin/bash

# Clear screen
clear

# Colors
GREEN="\e[32m"
CYAN="\e[36m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${CYAN}===== System Status Report =====${RESET}"

# Server name & uptime
echo -e "${YELLOW}Server Name:${RESET} $(hostname)"
echo -e "${YELLOW}Uptime:${RESET} $(uptime -p)"

# Current user & date
echo -e "${YELLOW}Current User:${RESET} $(whoami)"
echo -e "${YELLOW}Date:${RESET} $(date)"

echo ""

# Disk, Memory & CPU usage
echo -e "${GREEN}--- Disk Usage ---${RESET}"
df -h / | awk 'NR==1 || NR==2'

echo -e "${GREEN}\n--- Memory Usage ---${RESET}"
free -h

echo -e "${GREEN}\n--- CPU Load ---${RESET}"
uptime | awk -F'load average:' '{print $2}'

echo ""

# External IP
echo -e "${YELLOW}External IP:${RESET}"
curl -s ifconfig.me

echo ""

# Last 3 login attempts
echo -e "${CYAN}--- Last 3 Login Attempts ---${RESET}"
last -n 3

