#!/bin/bash

# Colors
CYAN="\e[36m"
GREEN="\e[32m"
RESET="\e[0m"

clear

echo -e "${CYAN}===== Server IP Information =====${RESET}"

# Private IP (handles eth0, ens*, enp*, wlan*, etc.)
PRIVATE_IP=$(hostname -I | awk '{print $1}')

# Public IP
PUBLIC_IP=$(curl -s ifconfig.me)

echo -e "${GREEN}Private IP:${RESET} $PRIVATE_IP"
echo -e "${GREEN}Public IP:${RESET}  $PUBLIC_IP"

echo -e "${CYAN}===============================${RESET}"

